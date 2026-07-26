# Design — Handmade Ceramics Online Store

## 1. Overview

The system is a single-vendor online storefront for handmade ceramics. A
React single-page storefront (`ceramics-webapp`) lets shoppers browse the
catalog, manage a cart, check out as a guest or as a signed-in customer, and
view order history. A Go backend (`ceramics-api`) owns the product catalog,
variant inventory, cart, checkout orchestration, and order records in its
own embedded database. Optional customer sign-in is delegated to the
platform's Thunder identity provider. Card payment is captured through
Stripe, and order-confirmation email is sent through a transactional email
provider. There is no admin/back-office UI in this scope — catalog and
inventory data are seeded/maintained directly in `ceramics-api`'s database.

## 2. Components

- **ceramics-webapp** (`web-application`) — the customer-facing storefront:
catalog browsing/search, product detail with variant selection, cart,
checkout, guest/account sign-in, and order history/lookup.
- **ceramics-api** (`service`) — the single backend: product catalog and
variant inventory, cart, checkout orchestration (Stripe payment capture,
inventory reservation, order creation), order confirmation email, and
order/order-history retrieval. Owns its own embedded SQLite database.

## 3. Capabilities

### ceramics-webapp

- **Catalog browsing** — product list with thumbnail, price, stock status;
search by keyword; filter/browse by category and attribute (FR-1, FR-2,
FR-5, FR-6).
- **Product detail &amp; variant selection** — full description, images,
per-variant price and stock, disabling out-of-stock variants (FR-2, FR-3,
FR-4).
- **Cart management** — add/update/remove line items, live subtotal,
cart persisted for guests (local/session storage) and synced server-side
for signed-in customers (FR-7 – FR-10).
- **Checkout flow** — shipping address + contact entry, flat shipping fee
display, order summary, Stripe card element/payment confirmation,
stock re-validation feedback (FR-11, FR-18 – FR-22).
- **Guest and account flows** — sign in / sign up via Thunder, guest
checkout, post-checkout "create an account" offer, saved addresses
(FR-12 – FR-17).
- **Order history &amp; lookup** — signed-in customer's past orders and
statuses; guest order lookup by reference + email (FR-15, FR-26, FR-27).

### ceramics-api

- **Catalog service** — CRUD-free (data-managed-out-of-band) read API for
products, variants, categories, and stock levels (FR-1 – FR-6).
- **Cart service** — server-side cart for signed-in customers keyed on
their user id; stateless cart validation endpoint for guests (FR-7 – FR-11).
- **Checkout &amp; payment orchestration** — creates a Stripe PaymentIntent,
re-validates and reserves inventory, confirms payment, atomically
decrements stock, and creates the order record on success; rolls back /
rejects on stock conflict or payment failure (FR-19 – FR-24).
- **Order confirmation email** — sends a confirmation email with order
reference after successful order creation (FR-25).
- **Order records &amp; lookup** — persists an immutable snapshot of items,
prices, shipping fee, and total per order; serves a signed-in customer's
order history and a guest's reference+email lookup (FR-26, FR-27, NFR-6).

## 4. Data Model

- **Product** — id, name, description, category, images\[\], base price,
active flag.
- **Variant** — id, product id, attributes (e.g. size, glaze color), price
(or price delta), sku, stock quantity.
- **Category** — id, name, slug.
- **Cart** (server-side, signed-in customers only) — id, user id, items\[\]
(variant id, quantity), updated at.
- **Customer** — id (Thunder subject), saved addresses\[\] (label, name,
street, city, region, postal code, country).
- **Order** — id, order reference, customer id (nullable for guest),
guest email (nullable), shipping address snapshot, line items snapshot
(variant id, name, variant attributes, unit price, quantity), subtotal,
shipping fee, total, currency, status (placed, paid, shipped, completed,
cancelled), Stripe payment intent id, created at.

## 5. Roles &amp; Access

`ceramics-api` treats catalog-read endpoints as public. Cart-sync, saved
addresses, and order-history endpoints require an authenticated caller
(`X-User-Id` injected by the gateway from the caller's Thunder token); guest
checkout and guest order lookup remain unauthenticated but are scoped by
the order reference + email pair, not by identity.

## 6. Interactions

- `ceramics-webapp` → `ceramics-api` — all catalog, cart, checkout, and
order-history/lookup calls.
- `ceramics-webapp` → Thunder Auth (`user-auth`) — OIDC sign-in/sign-up for
registered customers.
- `ceramics-api` → Thunder Auth (`user-auth`) — gateway-side JWT validation
and identity-header injection for authenticated calls.
- `ceramics-api` → Stripe (`stripe`) — creates and confirms PaymentIntents
for checkout.
- `ceramics-api` → Email Provider (`email-provider`) — sends order
confirmation emails.

## 7. Data Flow

1. **Browse &amp; add to cart** — shopper loads `ceramics-webapp`, browses/
 searches the catalog (read from `ceramics-api`), opens a product,
 selects an in-stock variant, and adds it to the cart (stored client-side
 for guests, synced to `ceramics-api` for signed-in customers).
2. **Checkout** — shopper proceeds to checkout; `ceramics-api` re-validates
 stock for every cart line, the webapp collects shipping/contact details
 (or reuses a saved address), and displays the order summary including
 the flat shipping fee.
3. **Payment** — the webapp requests a Stripe PaymentIntent from
 `ceramics-api`, confirms payment via Stripe's client SDK, and
 `ceramics-api` receives payment confirmation.
4. **Order creation** — on confirmed payment, `ceramics-api` performs a
 final atomic stock check + decrement, persists the immutable order
 snapshot, and sends a confirmation email via the email provider. If
 stock is no longer available, the order is rejected and no successful
 charge is retained.
5. **Post-purchase** — the shopper sees an order confirmation with a
 reference number; a registered customer can later view it in order
 history, and a guest can look it up by reference + email.