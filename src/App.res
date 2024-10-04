open Entry

@module("./exportFunctions.js")
external exportToFolder: array<(string, string)> => unit = "exportToFolder"

@module("./exportFunctions.js")
external exportToFile: string => unit = "exportToFile"

let intMax = (a, b) => {
  a > b ? a : b
}

@val @scope("Math") external intAbs: (int, int) => int = "abs"

let concatArray = x => {
  x->Array.reduce([], (a, c) => {
    Array.concat(a, c)
  })
}

module ControlledInput = {
  @react.component
  let make = (~initialValue, ~onSave, ~className="", ~placeholder="Untitled", ~editable=true) => {
    let (value, setValue) = React.useState(() => initialValue)
    let inputRef = React.useRef(Js.Nullable.null)

    let saveInput = () => {
      onSave(value)
    }

    let cancelInput = () => {
      setValue(_ => initialValue)
    }
    <input
      ref={ReactDOM.Ref.domRef(inputRef)}
      type_="text"
      className={className}
      placeholder={placeholder}
      onKeyDown={e => {
        switch e->ReactEvent.Keyboard.key {
        | "Enter" => saveInput()
        | "Escape" => cancelInput()
        | _ => ()
        }
      }}
      value={value}
      onBlur={_ => saveInput()}
      onChange={e => {
        setValue(ReactEvent.Form.target(e)["value"])
      }}
    />
  }
}

@react.component
let make = () => {
  // Theme.initiate()

  let (entries, setEntries, getEntries) = Common.useLocalStorage("data", None)

  let (entryToSet: option<string>, setEntryToSet, getEntryToSet) = Common.useStateWithGetter(() =>
    None
  )

  let (theme, setTheme) = Theme.useTheme()

  let scrollToRef = React.useRef(None)

  React.useEffectOnEveryRender(() => {
    scrollToRef.current
    ->Option.flatMap(x => x->Global.Derived.getElementByClassOp)
    ->Option.mapOr((), element => {
      element->Global.scrollIntoView({
        "behavior": "smooth",
        "block": "center",
      })

      scrollToRef.current = None
    })

    None
  })

  let (startYear, setStartYear, _) = Common.useLocalStorage("start-year", 2010)
  let (endYear, setEndYear, _) = Common.useLocalStorage("end-year", 2030)

  let startOfCal = Date.makeWithYMD(~year=startYear, ~month=0, ~date=1)
  let endOfCal = Date.makeWithYMD(~year=endYear + 1, ~month=0, ~date=1)

  let updateEntry = React.useCallback0((id, f) => {
    setEntries(v =>
      v->Option.map(
        v_ => {
          v_->Array.map(entry => entry.id == id ? f(entry) : entry)
        },
      )
    )
  })

  let sortEntries = data =>
    data->Option.map(v =>
      v->Array.toSorted((a, b) => {
        String.localeCompare(
          a.date->Option.mapOr("", x => x->entryDateString) ++ a.id,
          b.date->Option.mapOr("", x => x->entryDateString) ++ b.id,
        )
      })
    )
  // React.useEffect0(() => {
  //   setImportData(v => v->sortEntries)
  //   None
  // })

  let dateSet =
    entries
    ->Option.getOr([])
    ->Array.map(entry => entry.date)
    ->Array.keepSome
    ->Array.map(date => date->entryDateString)
    ->Set.fromArray

  let dateEntries =
    entries
    ->Option.getOr([])
    ->Array.map(entry => entry.date->Option.map(v => (v, entry)))
    ->Array.keepSome
    ->Array.map(((date, entry)) => (date->entryDateString, entry))
    ->Map.fromArray

  let makeNewEntry = entryDate => {
    setEntries(v => {
      v
      ->Option.map(entries =>
        Array.concat(
          entries,
          [
            {
              id: (entries->Array.reduce(
                0,
                (a, c) => intMax(a, c.id->Int.fromString->Option.getOr(0)),
              ) + 1)->Int.toString,
              date: entryDate->Some,
              title: "",
              content: "",
              lock: false,
              hide: false,
            },
          ],
        )
      )
      ->sortEntries
    })
  }
  let onClickDate = (entryDate, withMetaKey) => {
    getEntryToSet()->Option.mapOr(
      {
        entryDate
        ->Some
        ->entryClassNameId
        ->Global.Derived.getElementByClassOp
        ->{
          x =>
            switch x {
            | Some(element) =>
              element->Global.scrollIntoView({
                "behavior": "smooth",
                "block": "center",
              })

            | None =>
              if !withMetaKey {
                makeNewEntry(entryDate)
                scrollToRef.current = entryDate->Some->entryClassNameId->Some
              } else {
                // scroll To closest date
                getEntries()
                ->Option.getOr([])
                ->Belt.Array.reduce(None, (a, c) => {
                  let entryTime = entryDate->getEntryDateDate->Date.getTime

                  switch (c.date, a) {
                  | (Some(cDate), Some(aDate)) => {
                      let cTime = cDate->getEntryDateDate->Date.getTime
                      let aTime = aDate->getEntryDateDate->Date.getTime

                      (
                        Math.abs(cTime -. entryTime) < Math.abs(aTime -. entryTime) ? cDate : aDate
                      )->Some
                    }
                  | (Some(cDate), None) => Some(cDate)
                  | (None, Some(aDate)) => Some(aDate)
                  | (None, None) => None
                  }
                })
                ->Option.mapOr((), closestDate => {
                  closestDate
                  ->Some
                  ->entryClassNameId
                  ->Global.Derived.getElementByClassOp
                  ->Option.mapOr(
                    (),
                    element => {
                      element->Global.scrollIntoView({
                        "behavior": "smooth",
                        "block": "center",
                      })
                    },
                  )
                })
              }
            }
        }

        switch entryDate {
        | Date(y, _m, _d) =>
          `monthview-${Year(y)->entryDateString}`->Global.Derived.getElementByClassOp
        | Week(y, _w) => `monthview-${Year(y)->entryDateString}`->Global.Derived.getElementByClassOp
        | Year(y) => `dayview-${Date(y, 1, 1)->entryDateString}`->Global.Derived.getElementByIdOp
        | Quarter(y, q) =>
          `dayview-${Date(y, (q - 1) * 3, 1)->entryDateString}`->Global.Derived.getElementByIdOp
        | Month(y, m) =>
          `dayview-${Date(y, m, 1)->entryDateString}`->Global.Derived.getElementByIdOp
        }->Option.mapOr((), element => {
          element->Global.scrollIntoView({
            "behavior": "smooth",
            "block": "center",
          })
        })
      },
      entryId => {
        updateEntry(entryId, e => {
          ...e,
          date: Some(entryDate),
        })
        setEntryToSet(_ => None)
      },
    )
  }

  let formatContentForFile = entry => {
    "Date: " ++
    entry.date->Option.mapOr("", x => x->entryDateString) ++
    "\n" ++
    "Title: " ++
    entry.title ++
    "\n\n" ++
    entry.content
  }

  let onSort = () => {
    setEntries(v => v->sortEntries)
  }

  let onExportFile = () => {
    entries->Option.mapOr((), entries => {
      entries
      ->Array.map(v => v->formatContentForFile)
      ->Array.join("\n\n")
      ->exportToFile
    })
  }

  let onExportFolder = () => {
    entries->Option.mapOr((), entries => {
      entries
      ->Array.map(v => (
        v.date->Option.mapOr("", x => x->entryDateString) ++
        (v.date->Option.isSome && v.title != "" ? "_" : "") ++
        v.title ++ ".txt",
        v->formatContentForFile,
      ))
      ->exportToFolder
    })
  }

  let onShow = () => {
    setEntries(v => v->Option.map(entries => entries->Array.map(entry => {...entry, hide: false})))
  }

  let onHide = () => {
    setEntries(v => v->Option.map(entries => entries->Array.map(entry => {...entry, hide: true})))
  }

  let onLock = () => {
    setEntries(v => v->Option.map(entries => entries->Array.map(entry => {...entry, lock: true})))
  }

  let onUnlock = () => {
    setEntries(v => v->Option.map(entries => entries->Array.map(entry => {...entry, lock: false})))
  }

  // let dropdown =
  //   <div className="flex-none border-t border-plain-700 flex flex-row gap-2 items-center px-2">
  //     <Dropdown onSort onExportFile onExportFolder onShow onHide onLock onUnlock />
  //   </div>

  <div className="relative font-mono h-dvh flex flex-col bg-[--background] text-[--foreground]">
    <div className="flex flex-row flex-1 overflow-hidden">
      <div className="flex flex-col h-full flex-none w-64 border-r-transparent">
        <MenuBar.SmallBar
          onSort onExportFile onExportFolder onShow onHide onLock onUnlock theme setTheme
        />
        <Days
          start={startOfCal} end={endOfCal} dateSet={dateSet} dateEntries onClick={onClickDate}
        />
        <div
          className="flex flex-row justify-between w-full border-y border-[--foreground-500] text-xs py-1">
          <div className="flex-1 px-2 ">
            <ControlledInput
              initialValue={startYear->Int.toString}
              onSave={v => setStartYear(old => v->Int.fromString->Option.getOr(old))}
              className={"bg-inherit  w-full  text-center"}
              placeholder={"start year"}
            />
          </div>
          <div className="flex-none"> {"-"->React.string} </div>
          <div className="flex-1 px-2">
            <ControlledInput
              initialValue={endYear->Int.toString}
              onSave={v => setEndYear(old => v->Int.fromString->Option.getOr(old))}
              className={"bg-inherit  w-full   text-center"}
              placeholder={"end year"}
            />
          </div>
        </div>
        <Months start={startOfCal} end={endOfCal} dateSet={dateSet} onClick={onClickDate} />
      </div>
      <Entries
        entries={entries}
        updateEntry={updateEntry}
        setEntryToSet
        entryToSet
        deleteEntry={id => {
          setEntries(v => v->Option.map(entries => entries->Array.filter(entry => entry.id != id)))
        }}
      />
    </div>
    // <MenuBar onSort onExportFile onExportFolder onShow onHide onLock onUnlock theme setTheme />
  </div>
}

// let getDate = name => {
//   let date =
//     name
//     ->String.substring(~start=0, ~end=10)
//     ->DateFns.parse(standardDateFormat, 0)

//   date->isInvalidDate
//     ? None
//     : switch (
//         date->DateFns.format("y")->Int.fromString,
//         date->DateFns.format("MM")->Int.fromString,
//         date->DateFns.format("dd")->Int.fromString,
//       ) {
//       | (Some(y), Some(m), Some(d)) => Some(Date(y, m, d))
//       | _ => None
//       }
// }

// React.useEffect0(() => {
//   fetch("../testData/test.json")
//   ->Promise.then(response => {
//     json(response)
//   })
//   ->Promise.then(json => {
//     setImportData(
//       _ => Some(
//         json->Array.mapWithIndex(
//           ((name, content), i) => {
//             id: i->Int.toString,
//             date: getDate(name),
//             title: name,
//             content,
//           },
//         ),
//       ),
//     )
//     Promise.resolve()
//   })
//   ->ignore
//   None
// })
