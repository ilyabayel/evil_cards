@scope("window") @val
external addEventListener: (string, Dom.event => string) => unit = "addEventListener"
@scope("window") @val
external removeEventListener: (string, Dom.event => string) => unit = "removeEventListener"
@scope("window") @val
external openPage: (string) => unit = "open"
