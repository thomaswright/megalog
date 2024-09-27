// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as DateFns from "date-fns";
import * as Core__Int from "@rescript/core/src/Core__Int.res.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import MonacoJsx from "./Monaco.jsx";
import * as Color from "@texel/color";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as JsxRuntime from "react/jsx-runtime";
import UseLocalStorageJs from "./useLocalStorage.js";
import ReactTextareaAutosize from "react-textarea-autosize";

function scrollIntoView(x) {
  x.scrollIntoView({
        behavior: "smooth",
        block: "center"
      });
}

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

function getMonthForWeekOfYear(weekNumber, year) {
  var firstDayOfYear = new Date(year, 0, 1);
  var dayOfWeek = firstDayOfYear.getDay();
  if (dayOfWeek !== 1) {
    var offset = dayOfWeek === 0 ? 1 : 8 - dayOfWeek | 0;
    firstDayOfYear.setDate(firstDayOfYear.getDate() + offset | 0);
  }
  var dateOfWeek = new Date(firstDayOfYear.getTime());
  dateOfWeek.setDate(firstDayOfYear.getDate() + Math.imul(weekNumber - 1 | 0, 7) | 0);
  return dateOfWeek.getMonth() + 1 | 0;
}

function useStateWithGetter(initial) {
  var match = React.useState(initial);
  var state = match[0];
  var stateRef = React.useRef(state);
  React.useEffect((function () {
          stateRef.current = state;
        }), [state]);
  var getState = function () {
    return stateRef.current;
  };
  return [
          state,
          match[1],
          getState
        ];
}

function entryDateString(date) {
  switch (date.TAG) {
    case "Year" :
        return date._0.toString().padStart(4, "0");
    case "Half" :
        return date._0.toString().padStart(4, "0") + "-H" + date._1.toString();
    case "Quarter" :
        return date._0.toString().padStart(4, "0") + "-Q" + date._1.toString();
    case "Month" :
        return date._0.toString().padStart(4, "0") + "-" + date._1.toString().padStart(2, "0");
    case "Week" :
        return date._0.toString().padStart(4, "0") + "-W" + date._1.toString();
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

function monthHue(monthInt) {
  return 360 / 12 * Math.imul(monthInt - 3 | 0, 5) % 360.0;
}

var monthColors = Core__Array.make(12, false).map(function (param, i) {
      return hsl(monthHue(i), 1.0, 0.7);
    });

var monthColorsDim = Core__Array.make(12, false).map(function (param, i) {
      return hsl(monthHue(i), 1.0, 0.3);
    });

function monthColor(monthInt) {
  return monthColors[monthInt - 1 | 0];
}

function monthColorDim(monthInt) {
  return monthColorsDim[monthInt - 1 | 0];
}

function App$Months(props) {
  var onClick = props.onClick;
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
                                            JsxRuntime.jsx("button", {
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
                                                  },
                                                  onClick: (function (param) {
                                                      onClick({
                                                            TAG: "Year",
                                                            _0: year
                                                          });
                                                    })
                                                }),
                                            JsxRuntime.jsx("button", {
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
                                                  },
                                                  onClick: (function (param) {
                                                      onClick({
                                                            TAG: "Quarter",
                                                            _0: year,
                                                            _1: 1
                                                          });
                                                    })
                                                }),
                                            JsxRuntime.jsx("button", {
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
                                                  },
                                                  onClick: (function (param) {
                                                      onClick({
                                                            TAG: "Quarter",
                                                            _0: year,
                                                            _1: 2
                                                          });
                                                    })
                                                }),
                                            JsxRuntime.jsx("button", {
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
                                                  },
                                                  onClick: (function (param) {
                                                      onClick({
                                                            TAG: "Quarter",
                                                            _0: year,
                                                            _1: 3
                                                          });
                                                    })
                                                }),
                                            JsxRuntime.jsx("button", {
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
                                                  },
                                                  onClick: (function (param) {
                                                      onClick({
                                                            TAG: "Quarter",
                                                            _0: year,
                                                            _1: 4
                                                          });
                                                    })
                                                }),
                                            Core__Array.make(12, false).map(function (_v, i) {
                                                  var monthNum = (i + 1 | 0).toString();
                                                  var monthDate = new Date(year, i);
                                                  var hasEntry = dateSet.has(entryDateString({
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
                                                                  " flex flex-row items-center justify-center ",
                                                                  hasEntry ? "text-lime-500 bg-black" : "text-neutral-600 bg-black"
                                                                ].join(" "),
                                                              style: {
                                                                gridArea: "m" + monthNum
                                                              },
                                                              onClick: (function (param) {
                                                                  onClick({
                                                                        TAG: "Month",
                                                                        _0: year,
                                                                        _1: i + 1 | 0
                                                                      });
                                                                })
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

function App$Day(props) {
  var onClick = props.onClick;
  var dateSet = props.dateSet;
  var d = props.d;
  var beginningOfWeek = d.getDay() === 0;
  var year = d.getFullYear();
  var month = d.getMonth() + 1 | 0;
  var monthDay = d.getDate();
  var monthColor$1 = monthColor(month);
  var monthColorDim$1 = monthColorDim(month);
  var isToday = DateFns.isSameDay(new Date(), d);
  var tmp;
  if (true && beginningOfWeek) {
    var week = DateFns.format(d, "w");
    tmp = Core__Option.mapOr(Core__Int.fromString(week, undefined), null, (function (weekNum) {
            var hasWeekEntry = dateSet.has(entryDateString({
                      TAG: "Week",
                      _0: year,
                      _1: weekNum
                    }));
            return JsxRuntime.jsx("button", {
                        children: week,
                        className: "text-xs text-left  overflow-visible text-nowrap p-1",
                        style: {
                          color: hasWeekEntry ? monthColor$1 : "#ddd"
                        },
                        onClick: (function (param) {
                            onClick({
                                  TAG: "Week",
                                  _0: year,
                                  _1: weekNum
                                });
                          })
                      });
          }));
  } else {
    tmp = null;
  }
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
                              children: tmp,
                              className: " h-6 w-5 flex flex-row flex-none"
                            }),
                        JsxRuntime.jsx("div", {
                              className: ["w-1 h-6 flex-none"].join(" "),
                              style: {
                                backgroundColor: monthColor$1
                              }
                            }),
                        JsxRuntime.jsx("button", {
                              children: DateFns.format(d, "y-MM-dd eee"),
                              className: [
                                  "px-2 flex-none",
                                  isToday ? "border-r-4 border-white" : ""
                                ].join(" "),
                              style: {
                                color: props.hasEntry ? monthColor$1 : monthColorDim$1
                              },
                              onClick: (function (param) {
                                  onClick({
                                        TAG: "Date",
                                        _0: year,
                                        _1: month,
                                        _2: monthDay
                                      });
                                })
                            }),
                        JsxRuntime.jsx("div", {
                              children: "Singapore",
                              className: "text-neutral-500 flex-none"
                            })
                      ],
                      className: "flex flex-row items-center gap-1 text-sm h-6 max-h-6 whitespace-nowrap overflow-x-hidden",
                      id: "day-" + entryDateString({
                            TAG: "Date",
                            _0: year,
                            _1: month,
                            _2: monthDay
                          })
                    })
              ]
            });
}

var make = React.memo(App$Day, (function (a, b) {
        if (a.d.getTime() === b.d.getTime()) {
          return a.hasEntry === b.hasEntry;
        } else {
          return false;
        }
      }));

function App$Days(props) {
  var onClick = props.onClick;
  var dateSet = props.dateSet;
  return JsxRuntime.jsx("div", {
              children: allDays(props.start, props.end).map(function (d) {
                    return JsxRuntime.jsx(make, {
                                d: d,
                                dateSet: dateSet,
                                onClick: onClick,
                                hasEntry: dateSet.has(DateFns.format(d, "y-MM-dd"))
                              }, d.toString());
                  }),
              className: "w-full flex-2 p-2 overflow-y-scroll "
            });
}

var make$1 = React.memo(App$Days, (function (a, b) {
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

function entryClassNameId(entryDate) {
  return Core__Option.mapOr(entryDate, "", (function (date) {
                return "entry-" + entryDateString(date);
              }));
}

function App$Entry(props) {
  var setEntryToSet = props.setEntryToSet;
  var updateEntry = props.updateEntry;
  var entry = props.entry;
  var monthColor$1 = Core__Option.mapOr(entry.date, "#fff", (function (date) {
          switch (date.TAG) {
            case "Week" :
                return monthColor(getMonthForWeekOfYear(date._1, date._0));
            case "Month" :
            case "Date" :
                return monthColor(date._1);
            default:
              return "#fff";
          }
        }));
  var dateDisplay = Core__Option.flatMap(entry.date, (function (date) {
          if (date.TAG === "Date") {
            return DateFns.format(new Date(date._0, date._1 - 1 | 0, date._2), "y-MM-dd eee");
          } else {
            return entryDateString(date);
          }
        }));
  var isSelectedForSet = Core__Option.mapOr(props.entryToSet, false, (function (v) {
          return v === entry.id;
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
                            }),
                        JsxRuntime.jsx("button", {
                              children: "Set",
                              className: [
                                  "mx-1",
                                  isSelectedForSet ? "bg-blue-700 text-white" : "bg-white text-black"
                                ].join(" "),
                              onClick: (function (param) {
                                  setEntryToSet(function (v) {
                                        if (Caml_obj.equal(v, entry.id)) {
                                          return ;
                                        } else {
                                          return entry.id;
                                        }
                                      });
                                })
                            }),
                        JsxRuntime.jsx("button", {
                              children: "Go to date",
                              className: [
                                  "mx-1",
                                  "bg-white text-black"
                                ].join(" "),
                              onClick: (function (param) {
                                  Core__Option.mapOr(entry.date, undefined, (function (entryDate) {
                                          Core__Option.mapOr(Caml_option.nullable_to_opt(document.getElementById("day-" + entryDateString(entryDate))), undefined, (function (element) {
                                                  scrollIntoView(element);
                                                }));
                                        }));
                                })
                            })
                      ],
                      className: [
                          " py-2 border-b ",
                          entryClassNameId(entry.date)
                        ].join(" "),
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

var make$2 = React.memo(App$Entry, (function (a, b) {
        return false;
      }));

function App$Entries(props) {
  var entryToSet = props.entryToSet;
  var setEntryToSet = props.setEntryToSet;
  var updateEntry = props.updateEntry;
  return JsxRuntime.jsx("div", {
              children: Core__Option.mapOr(props.entries, null, (function (entries_) {
                      return entries_.map(function (entry) {
                                  return JsxRuntime.jsx(make$2, {
                                              entry: entry,
                                              updateEntry: updateEntry,
                                              setEntryToSet: setEntryToSet,
                                              entryToSet: entryToSet
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
  var match$1 = useStateWithGetter(function () {
        
      });
  var getEntryToSet = match$1[2];
  var setEntryToSet = match$1[1];
  var entryToSet = match$1[0];
  var scrollToRef = React.useRef(undefined);
  React.useEffect(function () {
        Core__Option.mapOr(Core__Option.flatMap(scrollToRef.current, (function (x) {
                    return Core__Option.flatMap(Caml_option.nullable_to_opt(document.getElementsByClassName(x)), (function (x) {
                                  return x[0];
                                }));
                  })), undefined, (function (element) {
                scrollIntoView(element);
                scrollToRef.current = undefined;
              }));
      });
  var startOfCal = new Date(2010, 0, 1);
  var endOfCal = new Date(2030, 0, 1);
  var updateEntry = React.useCallback((function (id, f) {
          setImportData(function (v) {
                return Core__Option.map(v, (function (v_) {
                              return v_.map(function (entry) {
                                          if (entry.id === id) {
                                            return f(entry);
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
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx("button", {
                            children: "Sort",
                            onClick: (function (param) {
                                setImportData(function (v) {
                                      return Core__Option.map(v, (function (v) {
                                                    return v.toSorted(function (a, b) {
                                                                return (Core__Option.mapOr(a.date, "", (function (x) {
                                                                                  return entryDateString(x);
                                                                                })) + a.id).localeCompare(Core__Option.mapOr(b.date, "", (function (x) {
                                                                                  return entryDateString(x);
                                                                                })) + b.id);
                                                              });
                                                  }));
                                    });
                              })
                          }),
                      className: "absolute top-1 right-1"
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsxs("div", {
                              children: [
                                JsxRuntime.jsx(make$1, {
                                      start: startOfCal,
                                      end: endOfCal,
                                      dateSet: dateSet,
                                      onClick: (function (entryDate) {
                                          Core__Option.mapOr(getEntryToSet(), Core__Option.mapOr(Core__Option.flatMap(Caml_option.nullable_to_opt(document.getElementsByClassName(entryClassNameId(entryDate))), (function (x) {
                                                          return x[0];
                                                        })), undefined, (function (v) {
                                                      scrollIntoView(v);
                                                    })), (function (entryId) {
                                                  updateEntry(entryId, (function (e) {
                                                          return {
                                                                  id: e.id,
                                                                  date: entryDate,
                                                                  title: e.title,
                                                                  content: e.content
                                                                };
                                                        }));
                                                  setEntryToSet(function (param) {
                                                        
                                                      });
                                                  scrollToRef.current = entryClassNameId(entryDate);
                                                }));
                                        })
                                    }),
                                JsxRuntime.jsx(App$Months, {
                                      start: startOfCal,
                                      end: endOfCal,
                                      dateSet: dateSet,
                                      onClick: (function (entryDate) {
                                          Core__Option.mapOr(entryToSet, Core__Option.mapOr(Core__Option.flatMap(Caml_option.nullable_to_opt(document.getElementsByClassName(entryClassNameId(entryDate))), (function (x) {
                                                          return x[0];
                                                        })), undefined, (function (v) {
                                                      scrollIntoView(v);
                                                    })), (function (entryId) {
                                                  updateEntry(entryId, (function (e) {
                                                          return {
                                                                  id: e.id,
                                                                  date: entryDate,
                                                                  title: e.title,
                                                                  content: e.content
                                                                };
                                                        }));
                                                  setEntryToSet(function (param) {
                                                        
                                                      });
                                                  scrollToRef.current = entryClassNameId(entryDate);
                                                }));
                                        })
                                    })
                              ],
                              className: "flex flex-col h-full flex-none w-64"
                            }),
                        JsxRuntime.jsx(App$Entries, {
                              entries: importData,
                              updateEntry: (function (id, newContent) {
                                  updateEntry(id, (function (e) {
                                          return {
                                                  id: e.id,
                                                  date: e.date,
                                                  title: e.title,
                                                  content: newContent
                                                };
                                        }));
                                }),
                              setEntryToSet: setEntryToSet,
                              entryToSet: entryToSet
                            })
                      ],
                      className: "flex flex-row h-full"
                    })
              ],
              className: "relative font-mono h-dvh"
            });
}

var make$3 = App;

export {
  make$3 as make,
}
/*  Not a pure module */
