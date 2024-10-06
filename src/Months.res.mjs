// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Entry from "./Entry.res.mjs";
import * as Theme from "./Theme.res.mjs";
import * as DateFns from "date-fns";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import * as DateDerived from "./DateDerived.res.mjs";
import * as JsxRuntime from "react/jsx-runtime";

function Months(props) {
  var onClick = props.onClick;
  var dateSet = props.dateSet;
  return JsxRuntime.jsx("div", {
              children: DateDerived.allYears(props.start, props.end).map(function (d) {
                    var year = d.getFullYear();
                    var hasYearEntry = dateSet.has(Entry.entryDateString({
                              TAG: "Year",
                              _0: year
                            }));
                    var hasQ1Entry = dateSet.has(Entry.entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 1
                            }));
                    var hasQ2Entry = dateSet.has(Entry.entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 2
                            }));
                    var hasQ3Entry = dateSet.has(Entry.entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 3
                            }));
                    var hasQ4Entry = dateSet.has(Entry.entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 4
                            }));
                    return JsxRuntime.jsxs("div", {
                                children: [
                                  JsxRuntime.jsx("button", {
                                        children: JsxRuntime.jsx("div", {
                                              children: DateFns.format(d, "y"),
                                              className: "-rotate-90"
                                            }),
                                        className: [
                                            "monthview-" + Entry.entryDateString({
                                                  TAG: "Year",
                                                  _0: year
                                                }),
                                            "font-medium text-sm leading-none flex flex-row items-center justify-center overflow-hidden"
                                          ].join(" "),
                                        style: {
                                          color: hasYearEntry ? "var(--m0)" : "inherit",
                                          gridArea: "year"
                                        },
                                        onClick: (function (e) {
                                            onClick({
                                                  TAG: "Year",
                                                  _0: year
                                                }, e.metaKey);
                                          })
                                      }),
                                  JsxRuntime.jsx("button", {
                                        children: JsxRuntime.jsx("div", {
                                              children: "Q1",
                                              className: ""
                                            }),
                                        className: [
                                            "monthview-" + Entry.entryDateString({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 1
                                                }),
                                            " flex flex-row items-center justify-center"
                                          ].join(" "),
                                        style: {
                                          color: hasQ1Entry ? "var(--m0)" : "inherit",
                                          gridArea: "q1"
                                        },
                                        onClick: (function (e) {
                                            onClick({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 1
                                                }, e.metaKey);
                                          })
                                      }),
                                  JsxRuntime.jsx("button", {
                                        children: JsxRuntime.jsx("div", {
                                              children: "Q2",
                                              className: ""
                                            }),
                                        className: [
                                            "monthview-" + Entry.entryDateString({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 2
                                                }),
                                            " flex flex-row items-center justify-center"
                                          ].join(" "),
                                        style: {
                                          color: hasQ2Entry ? "var(--m0)" : "inherit",
                                          gridArea: "q2"
                                        },
                                        onClick: (function (e) {
                                            onClick({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 2
                                                }, e.metaKey);
                                          })
                                      }),
                                  JsxRuntime.jsx("button", {
                                        children: JsxRuntime.jsx("div", {
                                              children: "Q3",
                                              className: ""
                                            }),
                                        className: [
                                            "monthview-" + Entry.entryDateString({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 3
                                                }),
                                            " flex flex-row items-center justify-center"
                                          ].join(" "),
                                        style: {
                                          color: hasQ3Entry ? "var(--m0)" : "inherit",
                                          gridArea: "q3"
                                        },
                                        onClick: (function (e) {
                                            onClick({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 3
                                                }, e.metaKey);
                                          })
                                      }),
                                  JsxRuntime.jsx("button", {
                                        children: JsxRuntime.jsx("div", {
                                              children: "Q4",
                                              className: ""
                                            }),
                                        className: [
                                            "monthview-" + Entry.entryDateString({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 4
                                                }),
                                            " flex flex-row items-center justify-center"
                                          ].join(" "),
                                        style: {
                                          color: hasQ4Entry ? "var(--m0)" : "inherit",
                                          gridArea: "q4"
                                        },
                                        onClick: (function (e) {
                                            onClick({
                                                  TAG: "Quarter",
                                                  _0: year,
                                                  _1: 4
                                                }, e.metaKey);
                                          })
                                      }),
                                  Core__Array.make(12, false).map(function (_v, i) {
                                        var monthNum = (i + 1 | 0).toString();
                                        var monthDate = new Date(year, i);
                                        var hasEntry = dateSet.has(Entry.entryDateString({
                                                  TAG: "Month",
                                                  _0: year,
                                                  _1: i + 1 | 0
                                                }));
                                        return JsxRuntime.jsx("button", {
                                                    children: JsxRuntime.jsx("div", {
                                                          children: DateFns.format(monthDate, "MMM"),
                                                          className: ""
                                                        }),
                                                    className: [
                                                        "monthview-" + Entry.entryDateString({
                                                              TAG: "Month",
                                                              _0: year,
                                                              _1: i + 1 | 0
                                                            }),
                                                        " flex flex-row items-center justify-center"
                                                      ].join(" "),
                                                    style: {
                                                      color: hasEntry ? Theme.monthVar(i + 1 | 0) : "inherit",
                                                      gridArea: "m" + monthNum
                                                    },
                                                    onClick: (function (e) {
                                                        onClick({
                                                              TAG: "Month",
                                                              _0: year,
                                                              _1: i + 1 | 0
                                                            }, e.metaKey);
                                                      })
                                                  }, monthNum);
                                      })
                                ],
                                className: "gap-px [&:first-child]:border-t border-b border-[--foreground-400]  text-[--foreground-300] py-1",
                                style: {
                                  display: "grid",
                                  gridTemplateAreas: "\n                    \"year q1 m1 m2 m3\"\n                    \"year q2 m4 m5 m6\"\n                    \"year q3 m7 m8 m9\"\n                    \"year q4 m10 m11 m12\"\n                  \n                    ",
                                  gridTemplateColumns: "1.25fr 1.25fr 2fr 2fr 2fr ",
                                  gridTemplateRows: " repeat(4, 1.0fr)"
                                }
                              }, year.toString());
                  }),
              className: "py-2  flex-1 overflow-y-scroll flex flex-col w-full font-black pr-3"
            });
}

var make = Months;

export {
  make ,
}
/* Entry Not a pure module */
