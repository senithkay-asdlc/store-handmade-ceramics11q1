# Requirements Specification — Handmade Ceramics Online Store

## 1. Overview

An online store for a single artisan/shop selling handmade ceramics. The
store presents a product catalog with variants and live inventory, lets
shoppers build a cart, and checks out with card payment via a third-party
payment gateway (e.g. Stripe). Customers may check out as a guest or create
an account for order history and faster future checkout. Shipping is a flat
rate added at checkout. There is no admin/back-office UI in this scope;
product catalog and inventory data are managed directly against the store's
data store (e.g. by the store owner or via a data-loading process) outside
the application.

## 2. Scope

### 2.1 In scope

- Public product catalog: browsing, searching, and filtering handmade
ceramics, including product detail pages with images, description, price,
and variant selection (e.g. size, glaze color).
- Per-variant inventory tracking that prevents purchase of out-of-stock
variants.
- Shopping cart: add/update/remove items, persisted across a session and
(for signed-in customers) across devices.
- Guest checkout and optional customer accounts (registration, login, order
history, saved shipping addresses).
- Checkout flow: shipping address entry, flat-rate shipping fee, order
summary, and card payment capture through a payment gateway.
- Order confirmation and order history (for registered customers).

### 2.2 Out of scope

- Multi-vendor/marketplace seller accounts — this is a single store owner's
catalog.
- Admin/back-office dashboard for managing products, inventory, or orders.
Catalog and inventory data are maintained directly in the underlying data
store by the store owner, outside this system.
- Calculated/carrier-based shipping rates and local pickup logistics.
- Manual/offline payment methods (cash, bank transfer).
- Returns/refunds processing workflows, promotions/discount codes, gift
cards, and reviews/ratings (unless added in a later revision).

## 3. Stakeholders and Users

## 4. Functional Requirements

### 4.1 Product Catalog

- FR-1: The system shall display a list of products with name, thumbnail
image, price, and stock status (in stock / out of stock).
- FR-2: The system shall let shoppers view a product detail page showing
full description, images, price, and available variants (e.g. size, glaze
color).
- FR-3: Each product variant shall have its own price (or price delta) and
inventory count.
- FR-4: The system shall prevent adding an out-of-stock variant to the cart
and shall clearly indicate out-of-stock variants on the product page.
- FR-5: The system shall let shoppers search products by name/keyword and
filter by category and/or attribute (e.g. color).
- FR-6: The system shall support browsing products by category.

### 4.2 Cart

- FR-7: The system shall let a shopper add a specific product variant and
quantity to a cart.
- FR-8: The system shall let a shopper view, update quantities in, and
remove items from the cart.
- FR-9: The system shall recompute cart subtotal whenever cart contents
change.
- FR-10: The cart shall persist for the duration of a guest's browsing
session at minimum, and shall persist across sessions/devices for a
signed-in customer.
- FR-11: The system shall re-validate item availability (stock) when the
shopper proceeds from cart to checkout, and shall flag any item that has
gone out of stock since being added.

### 4.3 Accounts

- FR-12: The system shall let a visitor create an account with email and
password (or equivalent credential).
- FR-13: The system shall let a registered customer log in and log out.
- FR-14: The system shall let a registered customer save one or more
shipping addresses for reuse at checkout.
- FR-15: The system shall let a registered customer view their past orders
and each order's status and contents.
- FR-16: The system shall let a shopper without an account complete
checkout as a guest, supplying shipping and contact details for that
order only.
- FR-17: The system shall offer a guest, at or after checkout, the option
to create an account using the details just entered.

### 4.4 Checkout and Payment

- FR-18: The system shall collect a shipping address (and contact email)
during checkout for both guest and registered customers.
- FR-19: The system shall apply a single flat-rate shipping fee to every
order, regardless of destination or order size.
- FR-20: The system shall display an order summary — line items, subtotal,
shipping fee, and total — before payment is submitted.
- FR-21: The system shall capture card payment through a third-party
payment gateway and shall not itself store raw card numbers.
- FR-22: The system shall create an order only after the payment gateway
confirms successful payment.
- FR-23: The system shall perform a final inventory check at order
placement and shall reject/roll back the order (without charging, or with
an automatic refund) if any item is no longer available.
- FR-24: On successful payment, the system shall decrement inventory for
each purchased variant and shall present an order confirmation to the
shopper.
- FR-25: The system shall notify the customer of their order confirmation
(e.g. via email) including an order reference number.

### 4.5 Orders

- FR-26: Every order shall have a status (e.g. placed, paid, shipped,
completed, cancelled) visible to the customer who placed it.
- FR-27: A guest may look up an order's status using the order reference
and the email address used at checkout.

## 5. Non-Functional Requirements

- NFR-1 (Security): Checkout and account flows shall use encrypted
transport (TLS) end-to-end; payment card data shall be handled solely by
the payment gateway (PCI scope minimized via redirect/tokenized
integration).
- NFR-2 (Data integrity): Inventory decrements shall be atomic with order
creation to prevent overselling under concurrent checkouts.
- NFR-3 (Availability): The catalog browsing and cart experience shall
remain usable even under partial degradation of the payment gateway
(e.g. shopper can still browse/build a cart if checkout is temporarily
unavailable).
- NFR-4 (Performance): Product listing and detail pages shall load within
typical web performance expectations (target: interactive within 2–3
seconds on a broadband connection).
- NFR-5 (Usability): The storefront shall be responsive and usable on
both desktop and mobile browsers.
- NFR-6 (Auditability): Every order shall retain an immutable record of
the items, prices, shipping fee, and total charged at the time of
purchase, independent of later catalog price changes.

## 6. Assumptions

- A-1: Product catalog and inventory content are authored/maintained
directly against the system's data store by the store owner; no in-app
admin UI is provided in this scope.
- A-2: A single supported currency and a single flat shipping rate apply
to all orders in this scope.
- A-3: A third-party payment gateway (e.g. Stripe) is available and
handles card capture, authorization, and PCI compliance.
- A-4: Email delivery (order confirmation) is available via a
transactional email capability.

## 7. Success Criteria

- A shopper can find a ceramic product, select a variant, add it to a
cart, and complete checkout with a card payment, receiving an order
confirmation — either as a guest or as a registered customer — without
the store overselling out-of-stock variants.