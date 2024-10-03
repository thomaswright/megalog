open Entry

@react.component
let make = (~start, ~end, ~dateSet, ~onClick) => {
  <div className="py-2  flex-1 overflow-y-scroll flex flex-col w-full font-black">
    {DateDerived.allYears(start, end)
    ->Array.map(d => {
      let year = d->Date.getFullYear
      let hasYearEntry = dateSet->Set.has(Year(year)->entryDateString)
      let hasQ1Entry = dateSet->Set.has(Quarter(year, 1)->entryDateString)
      let hasQ2Entry = dateSet->Set.has(Quarter(year, 2)->entryDateString)
      let hasQ3Entry = dateSet->Set.has(Quarter(year, 3)->entryDateString)
      let hasQ4Entry = dateSet->Set.has(Quarter(year, 4)->entryDateString)

      <div
        key={year->Int.toString}
        className="gap-px text-xs [&:first-child]:border-t border-b border-[--foreground-400]  text-[--foreground-300] py-1"
        style={{
          display: "grid",
          gridTemplateColumns: "1.25fr 1.25fr 2fr 2fr 2fr ",
          gridTemplateRows: " repeat(4, 1.0fr)",
          gridTemplateAreas: `
                    "year q1 m1 m2 m3"
                    "year q2 m4 m5 m6"
                    "year q3 m7 m8 m9"
                    "year q4 m10 m11 m12"
                  
                    `,
        }}>
        <button
          onClick={_ => onClick(Year(year))}
          className={[
            `monthview-${Year(year)->entryDateString}`,
            "font-medium text-sm leading-none flex flex-row items-center justify-center overflow-hidden",
          ]->Array.join(" ")}
          style={{
            gridArea: "year",
            color: hasYearEntry ? "var(--m0)" : "inherit",
          }}>
          <div className="-rotate-90"> {d->DateFns.format("y")->React.string} </div>
        </button>
        <button
          onClick={_ => onClick(Quarter(year, 1))}
          className={[
            `monthview-${Quarter(year, 1)->entryDateString}`,
            " flex flex-row items-center justify-center",
          ]->Array.join(" ")}
          style={{
            color: hasQ1Entry ? "var(--m0)" : "inherit",
            gridArea: "q1",
          }}>
          <div className=""> {"Q1"->React.string} </div>
          // <Icons.Snowflake />
        </button>
        <button
          onClick={_ => onClick(Quarter(year, 2))}
          className={[
            `monthview-${Quarter(year, 2)->entryDateString}`,
            " flex flex-row items-center justify-center",
          ]->Array.join(" ")}
          style={{
            color: hasQ2Entry ? "var(--m0)" : "inherit",
            gridArea: "q2",
          }}>
          <div className=""> {"Q2"->React.string} </div>
          // <Icons.Flower />
        </button>
        <button
          onClick={_ => onClick(Quarter(year, 3))}
          className={[
            `monthview-${Quarter(year, 3)->entryDateString}`,
            " flex flex-row items-center justify-center",
          ]->Array.join(" ")}
          style={{
            color: hasQ3Entry ? "var(--m0)" : "inherit",
            gridArea: "q3",
          }}>
          <div className=""> {"Q3"->React.string} </div>
          // <Icons.Umbrella />
        </button>
        <button
          onClick={_ => onClick(Quarter(year, 4))}
          className={[
            `monthview-${Quarter(year, 4)->entryDateString}`,
            " flex flex-row items-center justify-center",
          ]->Array.join(" ")}
          style={{
            color: hasQ4Entry ? "var(--m0)" : "inherit",
            gridArea: "q4",
          }}>
          <div className=""> {"Q4"->React.string} </div>
          // <Icons.Leaf />
        </button>
        {Array.make(~length=12, false)
        ->Array.mapWithIndex((_v, i) => {
          let monthNum = (i + 1)->Int.toString
          let monthDate = Date.makeWithYM(~year, ~month=i)
          let hasEntry = dateSet->Set.has(Month(year, i + 1)->entryDateString)

          <button
            key={monthNum}
            onClick={_ => onClick(Month(year, i + 1))}
            className={[
              `monthview-${Month(year, i + 1)->entryDateString}`,
              " flex flex-row items-center justify-center",
            ]->Array.join(" ")}
            style={{
              gridArea: "m" ++ monthNum,
              color: hasEntry ? Theme.monthVar(i + 1) : "inherit",
            }}>
            <div className=""> {monthDate->DateFns.format("MMM")->React.string} </div>
          </button>
        })
        ->React.array}
      </div>
    })
    ->React.array}
  </div>
}
