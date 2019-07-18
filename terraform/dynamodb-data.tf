# Products - Data

resource "aws_dynamodb_table_item" "test-product-1" {
    table_name = "${aws_dynamodb_table.products_table.name}"
    hash_key = "${aws_dynamodb_table.products_table.hash_key}"

    item = <<ITEM
{
    "ProductId" : {"S":"B07J6F8H3M"},
    "CategoryId" : {"S":"Toys"},
    "CategoryName" : {"S":"Toys"},
    "DisplayName" : {"S":"LEGO Star Wars Darth Vader’s Castle"},
    "Description" : {"S":"Build Darth Vader’s feature-packed castle on planet Mustafar with a buildable TIE Advanced Fighter for amazing LEGO Star Wars battling action! Includes a Darth Vader figure, Darth Vader (bacta tank) figure, 2 Royal Guard figures and an Imperial Transport Pilot Castle measures over 16” (41cm) high, 11” (28cm) wide and 9” (23cm) deep; TIE Advanced Fighter measures over 2” (6cm) high, 4” (11cm) wide and 3” (9cm) long 1060 pieces – Building brick set for boys and girls aged 9+ and for fans and big kids of all ages This LEGO Star Wars Darth Vader’s Castle 75251 construction toy includes lots of original LEGO building bricks for endless creative play"},
    "ListPrice" : {"N":"100"},
    "SalePrice" : {"N":"75"},
    "DiscountPercent" : {"N":"25"}
}
ITEM
}