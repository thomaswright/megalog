open Entry

@module("./exportFunctions.js")
external exportToFolder: array<(string, string)> => unit = "exportToFolder"

@module("./exportFunctions.js")
external exportToFile: string => unit = "exportToFile"

@module("./exportFunctions.js")
external exportToJsonFile: string => unit = "exportToJsonFile"

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

// let importPersonal = setEntries => {

//   React.useEffect0(() => {
//     Global.fetch("../testData/test.json")
//     ->Promise.then(response => {
//       Global.json(response)
//     })
//     ->Promise.then(json => {
//       setEntries(
//         _ =>
//           json->Array.mapWithIndex(
//             ((name, content), i) => {
//               id: i->Int.toString,
//               date: name->entryDateFromString,
//               title: name,
//               content,
//               lock: true,
//               hide: false,
//             },
//           ),
//       )
//       Promise.resolve()
//     })
//     ->ignore
//     None
//   })
// }

@react.component
let make = () => {
  Theme.initiate()

  let (entries, setEntries, getEntries) = Common.useLocalStorage(StorageKeys.data, [])

  let (entryToSet: option<string>, setEntryToSet, getEntryToSet) = Common.useStateWithGetter(() =>
    None
  )

  let (theme, setTheme) = Theme.useTheme()

  let scrollToRef = React.useRef(None)

  // importPersonal(setEntries)
  // React.useEffect0(() => {
  //   setEntries(_ => [])
  //   None
  // })
  // React.useEffect0(() => {
  //   setEntries(v => {
  //     v->Array.map(
  //       v => {
  //         ...v,
  //         title: "",
  //         content: v.content->String.trim,
  //       },
  //     )
  //   })
  //   None
  // })

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

  let (startYear, setStartYear, _) = Common.useLocalStorage(StorageKeys.startYear, 2020)
  let (endYear, setEndYear, _) = Common.useLocalStorage(StorageKeys.endYear, 2030)

  let startOfCal = Date.makeWithYMD(~year=startYear, ~month=0, ~date=1)
  let endOfCal = Date.makeWithYMD(~year=endYear + 1, ~month=0, ~date=1)

  let updateEntry = React.useCallback0((id, f) => {
    setEntries(v => v->Array.map(entry => entry.id == id ? f(entry) : entry))
  })

  let sortEntries = v =>
    v->Array.toSorted((a, b) => {
      String.localeCompare(
        a.date->Option.mapOr("", x => x->entryDateString) ++ a.id,
        b.date->Option.mapOr("", x => x->entryDateString) ++ b.id,
      )
    })
  // React.useEffect0(() => {
  //   setImportData(v => v->sortEntries)
  //   None
  // })

  let dateSet =
    entries
    ->Array.map(entry => entry.date)
    ->Array.keepSome
    ->Array.map(date => date->entryDateString)
    ->Set.fromArray

  let dateEntries =
    entries
    ->Array.map(entry => entry.date->Option.map(v => (v, entry)))
    ->Array.keepSome
    ->Array.map(((date, entry)) => (date->entryDateString, entry))
    ->Map.fromArray

  let maxId = entries =>
    entries->Array.reduce(0, (a, c) => intMax(a, c.id->Int.fromString->Option.getOr(0)))

  let makeNewEntry = entryDate => {
    setEntries(v => {
      [
        ...v,
        {
          id: (maxId(v) + 1)->Int.toString,
          date: entryDate->Some,
          title: "",
          content: "",
          lock: false,
          hide: false,
        },
      ]->sortEntries
    })
  }

  let onClickDate = (entryDate, withMetaKey) => {
    switch getEntryToSet() {
    | Some(entryId) => {
        updateEntry(entryId, e => {
          ...e,
          date: Some(entryDate),
        })
        setEntryToSet(_ => None)
      }
    | None => {
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
                  // Scroll Entry View
                  closestDate
                  ->Some
                  ->entryClassNameId
                  ->Global.Derived.getElementByClassOp
                  ->Option.mapOr((), element => {
                    element->Global.scrollIntoView({
                      "behavior": "smooth",
                      "block": "center",
                    })
                  })
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
      }
    }
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

  let formatForJson = entries => {
    entries->Array.map((entry): entryObj => {
      {
        "title": entry.title,
        "date": entry.date->Option.mapOr("", x => x->entryDateString),
        "content": entry.content,
      }
    })
  }

  let onImportJson = json => {
    setEntries(entries => {
      let maxId = entries->maxId
      let newEntries =
        json
        ->Array.filter(jsonEntry => {
          entries
          ->Array.filter(
            v => {
              v.date->Option.mapOr("", entryDateString) == jsonEntry["date"] &&
              v.title == jsonEntry["title"] &&
              v.content == jsonEntry["content"]
            },
          )
          ->Array.length == 0
        })
        ->Array.mapWithIndex((jsonEntry, i) => {
          title: jsonEntry["title"],
          date: jsonEntry["date"]->entryDateFromString,
          content: jsonEntry["content"],
          id: (maxId + i + 1)->Int.toString,
          lock: false,
          hide: false,
        })

      Array.concat(entries, newEntries)
    })
  }

  let onSort = () => {
    setEntries(v => v->sortEntries)
  }

  let onExportJson = () => {
    entries
    ->formatForJson
    ->Js.Json.stringifyAny
    ->Option.mapOr((), exportToJsonFile)
  }

  let onExportFile = () => {
    entries
    ->Array.map(v => v->formatContentForFile)
    ->Array.join("\n\n")
    ->exportToFile
  }

  let onExportFolder = () => {
    entries
    ->Array.map(v => (
      v.date->Option.mapOr("", x => x->entryDateString) ++
      (v.date->Option.isSome && v.title != "" ? "_" : "") ++
      v.title ++ ".txt",
      v->formatContentForFile,
    ))
    ->exportToFolder
  }

  let onShow = () => {
    setEntries(v => v->Array.map(entry => {...entry, hide: false}))
  }

  let onHide = () => {
    setEntries(v => v->Array.map(entry => {...entry, hide: true}))
  }

  let onLock = () => {
    setEntries(v => v->Array.map(entry => {...entry, lock: true}))
  }

  let onUnlock = () => {
    setEntries(v => v->Array.map(entry => {...entry, lock: false}))
  }

  // let dropdown =
  //   <div className="flex-none border-t border-plain-700 flex flex-row gap-2 items-center px-2">
  //     <Dropdown onSort onExportFile onExportFolder onShow onHide onLock onUnlock />
  //   </div>

  <div
    className="relative font-mono h-dvh flex flex-col bg-[--background] text-[--foreground] text-base sm:text-xs">
    <div className="flex flex-col sm:flex-row flex-1 overflow-hidden">
      <div
        className="flex-1 sm:flex-none flex flex-col sm:h-full  w-full sm:w-64 border-r-transparent overflow-hidden border-b sm:border-b-0 border-[--foreground]">
        <MenuBar.SmallBar
          onSort
          onExportFile
          onExportFolder
          onExportJson
          onShow
          onHide
          onLock
          onUnlock
          theme
          setTheme
          onImportJson
        />
        <Days
          start={startOfCal} end={endOfCal} dateSet={dateSet} dateEntries onClick={onClickDate}
        />
        <div className="pr-3 ">
          <div
            className="flex flex-row justify-between w-full border-y border-[--foreground-500]  py-1 items-center ">
            <div className="flex-1 px-2 ">
              <ControlledInput
                initialValue={startYear->Int.toString}
                onSave={v => setStartYear(old => v->Int.fromString->Option.getOr(old))}
                className={"bg-inherit  w-full  text-center"}
                placeholder={"start year"}
              />
            </div>
            <div className="flex-none"> {"-"->React.string} </div>
            <div className="flex-1 px-2 ">
              <ControlledInput
                initialValue={endYear->Int.toString}
                onSave={v => setEndYear(old => v->Int.fromString->Option.getOr(old))}
                className={"bg-inherit  w-full   text-center"}
                placeholder={"end year"}
              />
            </div>
            <div className="flex-none text-base -my-1 ">
              <button
                className="px-2"
                onClick={e => {
                  let entryDate = Date.make()->dateToEntryDate
                  onClickDate(entryDate, e->ReactEvent.Mouse.metaKey)
                  `dayview-${entryDate->entryDateString}`
                  ->Global.Derived.getElementByIdOp
                  ->Option.mapOr((), element => {
                    element->Global.scrollIntoView({
                      "behavior": "smooth",
                      "block": "center",
                    })
                  })
                }}>
                <Icons.CalendarDot />
              </button>
            </div>
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
          setEntries(v => v->Array.filter(entry => entry.id != id))
        }}
      />
    </div>
    // <MenuBar onSort onExportFile onExportFolder onShow onHide onLock onUnlock theme setTheme />
  </div>
}
