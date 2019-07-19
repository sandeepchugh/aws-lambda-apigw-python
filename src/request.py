

def parse_request(event):
    """
    Parses the input api gateway event and returns the product id
    Expects the input event to contain the pathPatameters dict with
    the productId key/value pair
    :param event: api gateway event
    :return: a dict containing the productId key/value
    """
    if 'pathParameters' not in event:
        raise Exception("Invalid event. Missing 'pathParameters'")

    path_parameters = event["pathParameters"]

    if 'productId' not in path_parameters:
        raise Exception("Invalid event. Missing 'productId' in 'pathParameters'")

    return {
        "product_id": path_parameters['productId']
    }
