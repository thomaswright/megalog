open Entry

@module("./exportFunctions.js")
external exportToFolder: array<(string, string)> => unit = "exportToFolder"

@module("./exportFunctions.js")
external exportToFile: string => unit = "exportToFile"

let intMax = (a, b) => {
  a > b ? a : b
}

let concatArray = x => {
  x->Array.reduce([], (a, c) => {
    Array.concat(a, c)
  })
}

@react.component
let make = () => {
  // Theme.initiate()

  let (entries, setEntries) = Common.useLocalStorage("data", None)

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

  let startOfCal = Date.makeWithYMD(~year=2010, ~month=0, ~date=1)
  let endOfCal = Date.makeWithYMD(~year=2030, ~month=0, ~date=1)

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
  let onClickDate = entryDate => {
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

            | None => {
                makeNewEntry(entryDate)
                scrollToRef.current = entryDate->Some->entryClassNameId->Some
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
      <div className="flex flex-col h-full flex-none w-64 border-r-8 border-r-transparent">
        <Days
          start={startOfCal} end={endOfCal} dateSet={dateSet} dateEntries onClick={onClickDate}
        />
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
    <MenuBar onSort onExportFile onExportFolder onShow onHide onLock onUnlock theme setTheme />
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
