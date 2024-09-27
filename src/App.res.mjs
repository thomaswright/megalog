// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as DateFns from "date-fns";
import * as Core__Int from "@rescript/core/src/Core__Int.res.mjs";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import MonacoJsx from "./Monaco.jsx";
import * as Color from "@texel/color";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as JsxRuntime from "react/jsx-runtime";
import UseLocalStorageJs from "./useLocalStorage.js";
import ReactTextareaAutosize from "react-textarea-autosize";

function entryDateString(date) {
  switch (date.TAG) {
    case "Year" :
        return date._0.toPrecision(4);
    case "Half" :
        return date._0.toPrecision(4) + "-H" + date._1.toPrecision(1);
    case "Quarter" :
        return date._0.toPrecision(4) + "-Q" + date._1.toPrecision(1);
    case "Month" :
        return date._0.toPrecision(4) + date._1.toPrecision(2);
    case "Week" :
        return date._0.toPrecision(4) + "-W" + date._1.toPrecision(2);
    case "Date" :
        return DateFns.format(new Date(date._0, date._1 - 1 | 0, date._2), "y-MM-dd");
    
  }
}

function allDays(start, end) {
  var inc = new Date(start.getTime());
  var dayDiff = Math.floor((end.getTime() - inc.getTime()) / 86400000) | 0;
  return Core__Array.make(dayDiff, false).map(function (param, _i) {
              var result = new Date(inc.getTime());
              inc.setDate(inc.getDate() + 1 | 0);
              return result;
            });
}

function hsl(h, s, l) {
  return Color.RGBToHex(Color.convert([
                  h,
                  s,
                  l
                ], Color.OKHSL, Color.sRGB));
}

function monthHue(monthInt, param) {
  return 360 / 12 * Math.imul(monthInt - 3 | 0, 5) % 360.0;
}

function monthColor(monthInt, year) {
  return hsl(monthHue(monthInt, year), 1.0, 0.7);
}

function monthColorDim(monthInt, year) {
  return hsl(monthHue(monthInt, year), 1.0, 0.3);
}

function App$Months(props) {
  var dateSet = props.dateSet;
  return JsxRuntime.jsx("div", {
              children: allDays(props.start, props.end).map(function (d) {
                    var beginningOfMonth = d.getDate() === 1;
                    var beginningOfYear = DateFns.getDayOfYear(d) === 1;
                    var year = d.getFullYear();
                    var hasYearEntry = dateSet.has(entryDateString({
                              TAG: "Year",
                              _0: year
                            }));
                    var hasQ1Entry = dateSet.has(entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 1
                            }));
                    var hasQ2Entry = dateSet.has(entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 2
                            }));
                    var hasQ3Entry = dateSet.has(entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 3
                            }));
                    var hasQ4Entry = dateSet.has(entryDateString({
                              TAG: "Quarter",
                              _0: year,
                              _1: 4
                            }));
                    if (beginningOfMonth) {
                      return JsxRuntime.jsx(React.Fragment, {
                                  children: beginningOfYear ? JsxRuntime.jsxs("div", {
                                          children: [
                                            JsxRuntime.jsx("div", {
                                                  children: JsxRuntime.jsx("div", {
                                                        children: DateFns.format(d, "y"),
                                                        className: "-rotate-90"
                                                      }),
                                                  className: [
                                                      " flex flex-row items-center justify-center",
                                                      hasYearEntry ? "text-lime-500 bg-black" : "text-neutral-300 bg-black"
                                                    ].join(" "),
                                                  style: {
                                                    gridArea: "year"
                                                  }
                                                }),
                                            JsxRuntime.jsx("div", {
                                                  children: JsxRuntime.jsx("div", {
                                                        children: "Q1",
                                                        className: ""
                                                      }),
                                                  className: [
                                                      " flex flex-row items-center justify-center",
                                                      hasQ1Entry ? "text-lime-500 bg-black" : "text-neutral-600 bg-black"
                                                    ].join(" "),
                                                  style: {
                                                    gridArea: "q1"
                                                  }
                                                }),
                                            JsxRuntime.jsx("div", {
                                                  children: JsxRuntime.jsx("div", {
                                                        children: "Q2",
                                                        className: ""
                                                      }),
                                                  className: [
                                                      " flex flex-row items-center justify-center",
                                                      hasQ2Entry ? "text-lime-500 bg-black" : "text-neutral-600 bg-black"
                                                    ].join(" "),
                                                  style: {
                                                    gridArea: "q2"
                                                  }
                                                }),
                                            JsxRuntime.jsx("div", {
                                                  children: JsxRuntime.jsx("div", {
                                                        children: "Q3",
                                                        className: ""
                                                      }),
                                                  className: [
                                                      " flex flex-row items-center justify-center",
                                                      hasQ3Entry ? "text-lime-500 bg-black" : "text-neutral-600 bg-black"
                                                    ].join(" "),
                                                  style: {
                                                    gridArea: "q3"
                                                  }
                                                }),
                                            JsxRuntime.jsx("div", {
                                                  children: JsxRuntime.jsx("div", {
                                                        children: "Q4",
                                                        className: ""
                                                      }),
                                                  className: [
                                                      " flex flex-row items-center justify-center",
                                                      hasQ4Entry ? "text-lime-500 bg-black" : "text-neutral-600 bg-black"
                                                    ].join(" "),
                                                  style: {
                                                    gridArea: "q4"
                                                  }
                                                }),
                                            Core__Array.make(12, false).map(function (_v, i) {
                                                  var monthNum = (i + 1 | 0).toString();
                                                  var monthDate = new Date(year, i);
                                                  var hasEntry = dateSet.has(entryDateString({
                                                            TAG: "Month",
                                                            _0: year,
                                                            _1: i + 1 | 0
                                                          }));
                                                  return JsxRuntime.jsx("div", {
                                                              children: JsxRuntime.jsx("div", {
                                                                    children: DateFns.format(monthDate, "MMM"),
                                                                    className: ""
                                                                  }),
                                                              className: [
                                                                  " flex flex-row items-center justify-center ",
                                                                  hasEntry ? "text-lime-500 bg-black" : "text-neutral-600 bg-black"
                                                                ].join(" "),
                                                              style: {
                                                                gridArea: "m" + monthNum
                                                              }
                                                            });
                                                })
                                          ],
                                          className: "gap-px text-xs bg-neutral-800 border border-neutral-800",
                                          style: {
                                            display: "grid",
                                            gridTemplateAreas: "\n                    \"year q1 m1 m2 m3\"\n                    \"year q2 m4 m5 m6\"\n                    \"year q3 m7 m8 m9\"\n                    \"year q4 m10 m11 m12\"\n                  \n                    ",
                                            gridTemplateColumns: "1fr 1.25fr 2fr 2fr 2fr ",
                                            gridTemplateRows: " repeat(4, 1.0fr)"
                                          }
                                        }) : null
                                });
                    } else {
                      return null;
                    }
                  }),
              className: "p-4 bg-black flex-1 overflow-y-scroll flex flex-col gap-2 w-full"
            });
}

function App$Days(props) {
  var dateSet = props.dateSet;
  return JsxRuntime.jsx("div", {
              children: allDays(props.start, props.end).map(function (d) {
                    var beginningOfWeek = d.getDay() === 0;
                    var week = DateFns.format(d, "w");
                    var year = d.getFullYear();
                    var hasEntry = dateSet.has(DateFns.format(d, "y-MM-dd"));
                    var hasWeekEntry = Core__Option.mapOr(Core__Int.fromString(week, undefined), false, (function (weekNum) {
                            return dateSet.has(entryDateString({
                                            TAG: "Week",
                                            _0: year,
                                            _1: weekNum
                                          }));
                          }));
                    var year$1 = d.getFullYear();
                    var month = Core__Option.getOr(Core__Int.fromString(DateFns.format(d, "M"), undefined), 0);
                    var monthColor$1 = monthColor(month, year$1);
                    var monthColorDim$1 = monthColorDim(month, year$1);
                    var isToday = DateFns.isSameDay(new Date(), d);
                    return JsxRuntime.jsxs(React.Fragment, {
                                children: [
                                  true && beginningOfWeek ? JsxRuntime.jsx("div", {
                                          children: JsxRuntime.jsx("div", {
                                                className: "h-px w-full absolute-translate-y-1/2",
                                                style: {
                                                  background: monthColor$1
                                                }
                                              }),
                                          className: "relative h-0 ml-px"
                                        }) : null,
                                  JsxRuntime.jsxs("div", {
                                        children: [
                                          JsxRuntime.jsx("div", {
                                                children: true && beginningOfWeek ? JsxRuntime.jsx("div", {
                                                        children: week,
                                                        className: "text-xs text-left  overflow-visible text-nowrap p-1",
                                                        style: {
                                                          color: hasWeekEntry ? monthColor$1 : "#ddd"
                                                        }
                                                      }) : null,
                                                className: " h-6 w-5 flex flex-row flex-none"
                                              }),
                                          JsxRuntime.jsx("div", {
                                                className: ["w-1 h-6 flex-none"].join(" "),
                                                style: {
                                                  backgroundColor: monthColor$1
                                                }
                                              }),
                                          JsxRuntime.jsx("div", {
                                                children: DateFns.format(d, "y-MM-dd eee"),
                                                className: [
                                                    "px-2 flex-none",
                                                    isToday ? "border-r-4 border-white" : ""
                                                  ].join(" "),
                                                style: {
                                                  color: hasEntry ? monthColor$1 : monthColorDim$1
                                                }
                                              }),
                                          JsxRuntime.jsx("div", {
                                                children: "Singapore",
                                                className: "text-neutral-500 flex-none"
                                              })
                                        ],
                                        className: "flex flex-row items-center gap-1 text-sm h-6 max-h-6 whitespace-nowrap overflow-x-hidden"
                                      })
                                ]
                              }, DateFns.format(d, "y-MM-dd"));
                  }),
              className: "w-full flex-2 p-2 overflow-y-scroll "
            });
}

var make = React.memo(App$Days, (function (a, b) {
        var dateSetId = function (x) {
          return Array.from(x.values()).toSorted(function (a, b) {
                        return a.localeCompare(b);
                      }).join("");
        };
        if (DateFns.format(a.start, "y-MM-dd") === DateFns.format(b.start, "y-MM-dd") && DateFns.format(a.end, "y-MM-dd") === DateFns.format(b.end, "y-MM-dd")) {
          return dateSetId(a.dateSet) === dateSetId(b.dateSet);
        } else {
          return false;
        }
      }));

function App$TextArea(props) {
  var onChange = props.onChange;
  return JsxRuntime.jsx(ReactTextareaAutosize, {
              value: props.content,
              className: "bg-black w-full",
              onChange: (function (e) {
                  var value = e.target.value;
                  onChange(value);
                })
            });
}

function App$Entry(props) {
  var updateEntry = props.updateEntry;
  var entry = props.entry;
  var monthColor$1 = Core__Option.mapOr(entry.date, "#fff", (function (date) {
          if (date.TAG === "Date") {
            return monthColor(date._1, 2000);
          } else {
            return "#fff";
          }
        }));
  var dateDisplay = Core__Option.flatMap(entry.date, (function (date) {
          if (date.TAG === "Date") {
            return DateFns.format(new Date(date._0, date._1 - 1 | 0, date._2), "y-MM-dd eee");
          }
          
        }));
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsxs("div", {
                      children: [
                        Core__Option.mapOr(dateDisplay, null, (function (dateDisplay_) {
                                return JsxRuntime.jsx("span", {
                                            children: dateDisplay_,
                                            className: "pr-2"
                                          });
                              })),
                        JsxRuntime.jsx("span", {
                              children: entry.title,
                              className: " text-white"
                            })
                      ],
                      className: " py-2 border-b ",
                      style: {
                        borderColor: monthColor$1,
                        color: monthColor$1
                      }
                    }),
                JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx("div", {
                            children: JsxRuntime.jsx(App$TextArea, {
                                  content: entry.content,
                                  onChange: (function (newValue) {
                                      updateEntry(entry.id, newValue);
                                    })
                                }),
                            className: "rounded overflow-hidden"
                          }),
                      className: "py-2"
                    })
              ]
            }, entry.id);
}

var make$1 = React.memo(App$Entry, (function (a, b) {
        return false;
      }));

function App$Entries(props) {
  var updateEntry = props.updateEntry;
  return JsxRuntime.jsx("div", {
              children: Core__Option.mapOr(props.entries, null, (function (entries_) {
                      return entries_.map(function (entry) {
                                  return JsxRuntime.jsx(make$1, {
                                              entry: entry,
                                              updateEntry: updateEntry
                                            });
                                });
                    })),
              className: "text-xs leading-none flex-1 h-full overflow-y-scroll"
            });
}

function App(props) {
  var match = UseLocalStorageJs("data", undefined);
  var setImportData = match[1];
  var importData = match[0];
  var startOfCal = new Date(2010, 0, 1);
  var endOfCal = new Date(2030, 0, 1);
  var updateEntry = React.useCallback((function (id, newValue) {
          setImportData(function (v) {
                return Core__Option.map(v, (function (v_) {
                              return v_.map(function (entry) {
                                          if (entry.id === id) {
                                            return {
                                                    id: entry.id,
                                                    date: entry.date,
                                                    title: entry.title,
                                                    content: newValue
                                                  };
                                          } else {
                                            return entry;
                                          }
                                        });
                            }));
              });
        }), []);
  var dateSet = new Set(Core__Array.keepSome(Core__Option.getOr(importData, []).map(function (entry) {
                  return entry.date;
                })).map(function (date) {
            return entryDateString(date);
          }));
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsxs("div", {
                    children: [
                      JsxRuntime.jsxs("div", {
                            children: [
                              JsxRuntime.jsx(make, {
                                    start: startOfCal,
                                    end: endOfCal,
                                    dateSet: dateSet
                                  }),
                              JsxRuntime.jsx(App$Months, {
                                    start: startOfCal,
                                    end: endOfCal,
                                    dateSet: dateSet
                                  })
                            ],
                            className: "flex flex-col h-full flex-none w-64"
                          }),
                      JsxRuntime.jsx(App$Entries, {
                            entries: importData,
                            updateEntry: updateEntry
                          })
                    ],
                    className: "flex flex-row h-full"
                  }),
              className: "font-mono h-dvh"
            });
}

var make$2 = App;

export {
  make$2 as make,
}
/* make Not a pure module */
