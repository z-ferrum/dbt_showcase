# Device standard fields

{% docs device_id %}
    Unique identifier of the device
{% enddocs %}
    
{% docs device_type_id %}
    Unique identifier the device type (1...5)
{% enddocs %}

# Store standard fields

{% docs store_id %}
    Unique identifier of the store
{% enddocs %}

{% docs customer_id %}
    Unique identifier of the customer
{% enddocs %}

{% docs store_name %}
    Name of the store
{% enddocs %}

{% docs store_address %}
    Address of the store
{% enddocs %}

{% docs store_city %}
    City where the store is located
{% enddocs %}

{% docs store_country %}
    Country where the store is located
{% enddocs %}

{% docs store_typology %}
    Type of the store depending on what it sells
{% enddocs %}

{% docs store_first_transaction_at %}
    First transaction made in the store with our devices
{% enddocs %}

{% docs store_created_at %}
    Date when the store signed a contract with us and ordered first device
{% enddocs %}

# Transaction standard fields

{% docs product_sku %}
    Unique identifier of the product (pencil, pen, etc.)
{% enddocs %}

{% docs transaction_id %}
    Unique identifier of the transaction. If transaction fails, the re-taken one will have a different id.
{% enddocs %}

{% docs transaction_status %}
    Status of the transaction (accepted, refused or canceled)
{% enddocs %}

{% docs transaction_amount_eurocents %}
    Amount of the transaction in eurocents
{% enddocs %}

{% docs transaction_created_at %}
    Timestamp when a transaction was made
{% enddocs %}