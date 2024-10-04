module Dropdown = {
  @react.component @module("./Dropdown.jsx")
  external make: (
    ~onSort: unit => unit,
    ~onExportFile: unit => unit,
    ~onExportFolder: unit => unit,
    ~onShow: unit => unit,
    ~onHide: unit => unit,
    ~onLock: unit => unit,
    ~onUnlock: unit => unit,
    ~theme: Theme.theme,
    ~setTheme: (Theme.theme => Theme.theme) => unit,
  ) => React.element = "default"
}

module SmallBar = {
  @react.component
  let make = (
    ~onSort: unit => unit,
    ~onExportFile: unit => unit,
    ~onExportFolder: unit => unit,
    ~onShow: unit => unit,
    ~onHide: unit => unit,
    ~onLock: unit => unit,
    ~onUnlock: unit => unit,
    ~theme,
    ~setTheme,
  ) => {
    <div
      className="text-xs flex-none border-b border-[--foreground-300] flex flex-row items-center">
      <Dropdown onSort onExportFile onExportFolder onShow onHide onLock onUnlock theme setTheme />
    </div>
  }
}

// @react.component
// let make = (
//   ~onSort: unit => unit,
//   ~onExportFile: unit => unit,
//   ~onExportFolder: unit => unit,
//   ~onShow: unit => unit,
//   ~onHide: unit => unit,
//   ~onLock: unit => unit,
//   ~onUnlock: unit => unit,
//   ~theme,
//   ~setTheme,
// ) => {
//   <div
//     className="text-xs flex-none border-t border-[--foreground-300] flex flex-row gap-6 items-center px-2 py-2">
//     <button onClick={_ => onSort()}> {"Sort"->React.string} </button>
//     <button onClick={_ => onExportFile()}> {"Export as File"->React.string} </button>
//     <button onClick={_ => onExportFolder()}> {"Export as Folder"->React.string} </button>
//     <div className="flex flex-row justify-around gap-6 text-base">
//       <button onClick={_ => onShow()}>
//         <Icons.Eye />
//       </button>
//       <button onClick={_ => onHide()}>
//         <Icons.EyeClosed />
//       </button>
//       <button onClick={_ => onLock()}>
//         <Icons.Lock />
//       </button>
//       <button onClick={_ => onUnlock()}>
//         <Icons.LockOpen />
//       </button>
//       <button onClick={_ => setTheme(t => t == Theme.Dark ? Theme.Light : Theme.Dark)}>
//         {theme == Theme.Dark ? <Icons.Moon /> : <Icons.Sun />}
//       </button>
//     </div>
//     <Dropdown onSort onExportFile onExportFolder onShow onHide onLock onUnlock theme setTheme />
//   </div>
// }
