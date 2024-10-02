@val @scope("document")
external getElementById: string => Js.Nullable.t<Dom.element> = "getElementById"

@val @scope("document")
external getElementsByClassName: string => Js.Nullable.t<array<Dom.element>> =
  "getElementsByClassName"

@val @scope(("document", "documentElement", "classList"))
external addClassToHtmlElement: string => unit = "add"

@val @scope(("document", "documentElement", "classList"))
external removeClassToHtmlElement: string => unit = "remove"

@val @scope(("window", "localStorage"))
external localStorageGetItem: string => string = "getItem"

@val @scope("document")
external documentQuerySelector: string => Js.Nullable.t<Dom.element> = "querySelector"

@send
external scrollIntoView: (Dom.element, {"behavior": string, "block": string}) => unit =
  "scrollIntoView"

@send
external focus: Dom.element => unit = "focus"

@set
external selectionStart: (Dom.element, int) => unit = "selectionStart"

@set
external selectionEnd: (Dom.element, int) => unit = "selectionEnd"

@send
external querySelector: (Dom.element, string) => Js.Nullable.t<Dom.element> = "querySelector"

@get @scope("value") external textAreaLength: Dom.element => int = "length"

type importData = array<(string, string)>

type response

@send external json: response => promise<importData> = "json"

@val
external fetch: string => promise<response> = "fetch"

@val external isInvalidDate: Date.t => bool = "isNaN"

module Derived = {
  let getElementByClassOp = s =>
    s
    ->getElementsByClassName
    ->Js.Nullable.toOption
    ->Option.flatMap(x => x->Array.get(0))

  let getElementByIdOp = s =>
    s
    ->getElementById
    ->Js.Nullable.toOption
}
