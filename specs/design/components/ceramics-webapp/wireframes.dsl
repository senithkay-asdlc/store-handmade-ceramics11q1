// Handmade Ceramics Storefront — customer-facing screens

screen Catalog "Shoppers browse and search the ceramics catalog"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  row
    heading "Handmade Ceramics"
    right
    search "Search mugs, bowls, vases…"
    select "Category: All"
  row
    card "Mugs"
      image "Mug thumbnail" 200x140
      text "Speckled Stoneware Mug — $28"
      badge "In stock" success
    card "Bowls"
      image "Bowl thumbnail" 200x140
      text "Wide Serving Bowl — $46"
      badge "In stock" success
    card "Vases"
      image "Vase thumbnail" 200x140
      text "Tall Reactive-Glaze Vase — $72"
      badge "Out of stock" danger
  row
    right
    button "View product" primary -> ProductDetail

screen ProductDetail "Shopper reviews a product and selects a variant before adding to cart"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  breadcrumb "Shop / Mugs / Speckled Stoneware Mug"
  split 60/40
    left
      image "Speckled Stoneware Mug — gallery" 480x360
      text "Hand-thrown stoneware mug with a speckled glaze. Microwave and dishwasher safe. Holds 12oz."
    right
      heading "Speckled Stoneware Mug"
      text "$28.00"
      select "Size: Medium (12oz)"
      row
        badge "Sage Green" success
        badge "Slate Blue" success
        badge "Charcoal — Out of stock" danger
      input "Quantity: 1"
      row
        right
        button "Add to cart" primary -> Cart

screen Cart "Shopper reviews items before checkout"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  heading "Your Cart"
  table "Item | Variant | Qty | Price | "
    row "Speckled Stoneware Mug | Sage Green, Medium | 2 | $56.00 | Remove"
    row "Wide Serving Bowl | Natural, Large | 1 | $46.00 | Remove"
  card "Order total"
    text "Subtotal | $102.00"
    text "Shipping (flat rate) | $6.00"
    text "Total | $108.00"
  row
    right
    button "Continue shopping"
    button "Checkout" primary -> Checkout

screen Checkout "Shopper enters shipping details and pays, as a guest or signed in"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  breadcrumb "Cart / Checkout"
  split 60/40
    left
      heading "Shipping details"
      tabs "Guest checkout | Use saved address"
      input "Email address"
      input "Full name"
      input "Street address"
      row
        input "City"
        input "Postal code"
      select "Country: United States"
      checkbox "Create an account with these details"
      heading "Payment"
      input "Card number"
      row
        input "Expiry"
        input "CVC"
    right
      card "Order summary"
        text "Speckled Stoneware Mug ×2 | $56.00"
        text "Wide Serving Bowl ×1 | $46.00"
        divider
        text "Subtotal | $102.00"
        text "Shipping | $6.00"
        text "Total | $108.00"
      button "Place order" primary -> OrderConfirmation

screen OrderConfirmation "Shopper sees confirmation right after a successful payment"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  card "Order confirmed"
    heading "Thank you for your order!"
    text "Order reference: CER-20481"
    text "A confirmation email has been sent to jane@example.com"
    badge "Placed" success
  table "Item | Variant | Qty | Price"
    row "Speckled Stoneware Mug | Sage Green, Medium | 2 | $56.00"
    row "Wide Serving Bowl | Natural, Large | 1 | $46.00"
  row
    right
    button "View order status" -> OrderHistory
    button "Continue shopping" primary -> Catalog

screen OrderHistory "Signed-in customer views past orders and saved addresses"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  sidebar "Order history | Saved addresses | Account details"
  heading "Your Orders"
  table "Order | Date | Total | Status | "
    row "CER-20481 | Jul 20, 2026 | $108.00 | Placed | View →"
    row "CER-19902 | Jun 3, 2026 | $72.00 | Completed | View →"
    row "CER-18820 | Apr 11, 2026 | $46.00 | Cancelled | View →"
  heading "Saved addresses"
  card "Home"
    text "Jane Doe, 12 Kiln Street, Springfield, 45678"
    button "Edit"
  button "Add new address"

screen GuestOrderLookup "Guest checks an order's status using reference + email"
  navbar "Ceramics Co | Shop | Cart | Orders | Sign in"
  heading "Track your order"
  text "Enter your order reference and the email you used at checkout."
  input "Order reference — e.g. CER-20481"
  input "Email address"
  row
    right
    button "Look up order" primary -> OrderConfirmation
