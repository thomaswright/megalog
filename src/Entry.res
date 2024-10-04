type entryDate =
  | Year(int)
  | Quarter(int, int)
  | Month(int, int)
  | Week(int, int)
  | Date(int, int, int)

type entry = {
  id: string,
  date: option<entryDate>,
  title: string,
  content: string,
  lock: bool,
  hide: bool,
}

let dateToEntryDate = d => {
  let year = d->Date.getFullYear
  let month = d->Date.getMonth + 1
  let monthDay = d->Date.getDate

  Date(year, month, monthDay)
}

let entryDateString = date =>
  switch date {
  | Date(y, m, d) =>
    Date.makeWithYMD(~year=y, ~month=m - 1, ~date=d)->DateFns.format(Common.standardDateFormat)
  | Year(y) => y->Int.toString->String.padStart(4, "0")
  | Quarter(y, q) => y->Int.toString->String.padStart(4, "0") ++ "-Q" ++ q->Int.toString
  | Month(y, m) =>
    y->Int.toString->String.padStart(4, "0") ++ "-" ++ m->Int.toString->String.padStart(2, "0")
  | Week(y, w) => y->Int.toString->String.padStart(4, "0") ++ "-W" ++ w->Int.toString
  }

let entryClassNameId = entryDate => {
  entryDate->Option.mapOr("", date => {
    "entryview-" ++ date->entryDateString
  })
}

module Monaco = {
  @react.component @module("./Monaco.jsx")
  external make: (~content: string) => React.element = "default"
}

module TextareaAutosize = {
  @react.component @module("react-textarea-autosize")
  external make: (
    ~value: string,
    ~className: string,
    ~onChange: ReactEvent.Form.t => unit,
    ~readOnly: bool,
    ~disabled: bool,
  ) => React.element = "default"
}

module TextArea = {
  @react.component
  let make = (
    ~content: string,
    ~onChange: string => unit,
    ~className="",
    ~readonly=false,
    ~disabled=false,
  ) => {
    <TextareaAutosize
      readOnly={readonly}
      disabled={disabled}
      className={["w-full bg-transparent", className]->Array.join(" ")}
      value={content}
      onChange={e => {
        let value = (e->ReactEvent.Form.target)["value"]
        onChange(value)
      }}
    />
  }
}

module Editor = TextArea

module Entry = {
  @react.component
  let make = (
    ~entry,
    ~updateEntry: (string, entry => entry) => unit,
    ~setEntryToSet,
    ~isSelectedForSet,
    ~deleteEntry,
  ) => {
    let monthColor =
      entry.date
      ->Option.flatMap(date => {
        switch date {
        | Date(_y, m, _d) => Theme.monthVar(m)->Some
        | Month(_y, m) => Theme.monthVar(m)->Some
        | Week(y, w) => DateDerived.getMonthForWeekOfYear(w, y)->Theme.monthVar->Some
        | _ => None
        }
      })
      ->Option.getOr(Theme.monthVar(0))

    let dateDisplay = entry.date->Option.flatMap(date => {
      switch date {
      | Date(y, m, d) =>
        Date.makeWithYMD(~year=y, ~month=m - 1, ~date=d)->DateFns.format("y-MM-dd eee")->Some
      | x => x->entryDateString->Some
      }
    })

    let goToDay = () =>
      entry.date->Option.mapOr((), entryDate => {
        let dayMatch = switch entryDate {
        | Date(y, m, d) => Date(y, m, d)
        | Week(y, w) => Week(y, w)
        | Year(y) => Date(y, 0, 1)
        | Quarter(y, q) => Date(y, q - 1 * 3, 1)
        | Month(y, m) => Date(y, m, 1)
        }

        `dayview-${dayMatch->entryDateString}`
        ->Global.Derived.getElementByIdOp
        ->Option.mapOr((), element => {
          element->Global.scrollIntoView({
            "behavior": "smooth",
            "block": "center",
          })
        })

        let monthMatch = switch entryDate {
        | Date(y, m, _d) => Month(y, m)
        | Week(y, w) => Month(y, DateDerived.getMonthForWeekOfYear(w, y))
        | Year(y) => Year(y)
        | Quarter(y, q) => Quarter(y, q)
        | Month(y, m) => Month(y, m)
        }
        `monthview-${monthMatch->entryDateString}`
        ->Global.Derived.getElementByClassOp
        ->Option.mapOr((), element => {
          element->Global.scrollIntoView({
            "behavior": "smooth",
            "block": "center",
          })
        })
      })
    <div key={entry.id}>
      <div
        className={[
          entry.date->entryClassNameId,
          "heading py-1 border-b flex flex-row items-center pr-4",
        ]->Array.join(" ")}
        style={{
          color: monthColor,
          borderColor: monthColor,
        }}>
        {dateDisplay->Option.mapOr(React.null, dateDisplay_ => {
          <span
            className="cursor-pointer mr-2 font-black py-1.5"
            style={{
              color: isSelectedForSet ? "var(--background)" : monthColor,
              backgroundColor: isSelectedForSet ? monthColor : "transparent",
            }}
            onClick={_ => {
              if isSelectedForSet {
                setEntryToSet(_ => None)
              } else {
                goToDay()
              }
            }}>
            {dateDisplay_->React.string}
          </span>
        })}
        <input
          readOnly={entry.lock}
          type_="text"
          className={"flex-1 bg-inherit text-[--foreground] min-w-8 italic font-light outline-none leading-none padding-none border-none h-5 -my-1"}
          placeholder={""}
          value={entry.title}
          onChange={e => {
            updateEntry(entry.id, v => {
              ...v,
              title: ReactEvent.Form.target(e)["value"],
            })
          }}
        />
        <span className="flex-none w-4" />
        <span className="flex flex-row items-center gap-4 text-base">
          {entry.lock
            ? <React.Fragment>
                {entry.hide
                  ? <Icons.EyeClosed className={"text-[--foreground-300]"} />
                  : React.null}
                <button
                  className={"text-[--foreground-300]"}
                  onClick={_ => updateEntry(entry.id, v => {...v, lock: false})}>
                  <Icons.Lock />
                </button>
              </React.Fragment>
            : <React.Fragment>
                <button
                  style={{
                    color: isSelectedForSet ? "var(--foreground)" : monthColor,
                  }}
                  onClick={_ => setEntryToSet(v => v == Some(entry.id) ? None : Some(entry.id))}>
                  {isSelectedForSet ? <Icons.CalendarX /> : <Icons.Calendar />}
                </button>
                <button onClick={_ => deleteEntry(entry.id)}>
                  <Icons.Trash />
                </button>
                <button
                  onClick={_ =>
                    updateEntry(entry.id, v => {
                      {
                        ...v,
                        hide: !v.hide,
                      }
                    })}>
                  {entry.hide ? <Icons.EyeClosed /> : <Icons.Eye />}
                </button>
                <button
                  className={"text-[--foreground]"}
                  onClick={_ => updateEntry(entry.id, v => {...v, lock: true})}>
                  <Icons.LockOpen />
                  // {"Lock"->React.string}
                </button>
              </React.Fragment>}
        </span>
      </div>
      <div className="py-2">
        <div className="rounded overflow-hidden">
          {entry.hide
            ? React.null
            : <Editor
                className={[
                  "editor scroll-m-20 ",
                  entry.hide ? "text-transparent select-none" : "",
                ]->Array.join(" ")}
                content={entry.content}
                onChange={newContent => updateEntry(entry.id, v => {...v, content: newContent})}
                readonly={entry.lock}
                disabled={entry.hide}
              />}
        </div>
      </div>
    </div>
  }

  let make = React.memoCustomCompareProps(make, (a, b) => {
    // false
    switch (a.entry.date, b.entry.date) {
    | (Some(x), Some(y)) => x->entryDateString == y->entryDateString
    | (None, None) => true
    | _ => false
    } &&
    a.entry.content == b.entry.content &&
    a.entry.lock == b.entry.lock &&
    a.entry.hide == b.entry.hide &&
    a.entry.title == b.entry.title &&
    a.isSelectedForSet == b.isSelectedForSet
  })
}
module Entries = {
  @react.component
  let make = (
    ~entries: option<array<entry>>,
    ~updateEntry: (string, entry => entry) => unit,
    ~setEntryToSet,
    ~entryToSet,
    ~deleteEntry,
  ) => {
    <div className="text-xs leading-none flex-1 h-full overflow-y-scroll max-w-xl">
      {entries->Option.mapOr(React.null, entries_ => {
        entries_
        ->Array.map(entry => {
          let isSelectedForSet = entryToSet->Option.mapOr(false, v => v == entry.id)

          <Entry key={entry.id} entry updateEntry setEntryToSet isSelectedForSet deleteEntry />
        })
        ->React.array
      })}
    </div>
  }
}
