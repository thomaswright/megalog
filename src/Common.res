let concatArray = x => {
  x->Array.reduce([], (a, c) => {
    Array.concat(a, c)
  })
}

@module("marked") external parseMd: string => string = "parse"

@module("./useLocalStorage.js")
external useLocalStorage: (string, 'a) => ('a, ('a => 'a) => unit, unit => 'a) = "default"

@module("./useLocalStorage.js")
external useLocalStorageListener: (string, 'a) => 'a = "useLocalStorageListener"

let standardDateFormat = "y-MM-dd"

let useStateWithGetter = initial => {
  let (state, setState) = React.useState(initial)
  let stateRef = React.useRef(state)

  React.useEffect1(() => {
    stateRef.current = state
    None
  }, [state])

  let getState = () => stateRef.current

  (state, setState, getState)
}

let monthToEmoji = m => {
  switch m {
  | 0 => "❄️"
  | 1 => "❤️"
  | 2 => "🍀"
  | 3 => "🌧️"
  | 4 => "🌷"
  | 5 => "☀️"
  | 6 => "🍉"
  | 7 => "🏖️"
  | 8 => "📚"
  | 9 => "🎃"
  | 10 => "🍁"
  | 11 => "🎄"
  | _ => ""
  }
}
