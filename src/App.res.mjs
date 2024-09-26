// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as DateFns from "date-fns";
import * as Core__Int from "@rescript/core/src/Core__Int.res.mjs";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import * as Color from "@texel/color";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Lu from "react-icons/lu";
import * as JsxRuntime from "react/jsx-runtime";

function allDays() {
  var start = new Date(2020, 0, 1);
  var end = new Date(2025, 0, 1);
  var dayDiff = Math.floor((end.getTime() - start.getTime()) / 86400000) | 0;
  return Core__Array.make(dayDiff, false).map(function (param, i) {
              var result = new Date(start.getTime());
              start.setDate(start.getDate() + 1 | 0);
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
  return 360 / 12 * Math.imul(monthInt, 7) % 360.0;
}

function monthColor(monthInt, year) {
  console.log(monthInt, monthHue(monthInt, year));
  return hsl(monthHue(monthInt, year), 1.0, 0.7);
}

function monthColorDim(monthInt, year) {
  return hsl(monthHue(monthInt, year), 1.0, 0.3);
}

function App(props) {
  return JsxRuntime.jsx("div", {
              children: JsxRuntime.jsxs("div", {
                    children: [
                      JsxRuntime.jsx("div", {
                            children: allDays().map(function (d) {
                                  var month = Core__Option.getOr(Core__Int.fromString(DateFns.format(d, "M"), undefined), 0);
                                  var beginningOfMonth = d.getDate() === 1;
                                  var beginningOfYear = DateFns.getDayOfYear(d) === 1;
                                  var beginningOfQuarter = month % 3 === 1;
                                  var beginningOfHalf = month % 6 === 1;
                                  var year = d.getFullYear();
                                  monthColor(month, year);
                                  monthColorDim(month, year);
                                  if (beginningOfMonth) {
                                    return JsxRuntime.jsxs(React.Fragment, {
                                                children: [
                                                  beginningOfYear ? JsxRuntime.jsx("div", {
                                                          children: DateFns.format(d, "y"),
                                                          className: "text-red-500"
                                                        }) : null,
                                                  JsxRuntime.jsxs("div", {
                                                        children: [
                                                          JsxRuntime.jsx("div", {
                                                                children: DateFns.format(d, "MMM"),
                                                                className: ""
                                                              }),
                                                          beginningOfQuarter ? JsxRuntime.jsx("div", {
                                                                  children: "Q" + DateFns.format(d, "q")
                                                                }) : null,
                                                          beginningOfHalf ? JsxRuntime.jsx("div", {
                                                                  children: month === 1 ? "H1" : (
                                                                      month === 7 ? "H2" : ""
                                                                    )
                                                                }) : null
                                                        ],
                                                        className: "flex flex-row h-4 text-sm gap-1"
                                                      })
                                                ]
                                              });
                                  } else {
                                    return null;
                                  }
                                }),
                            className: "w-20"
                          }),
                      JsxRuntime.jsx("div", {
                            children: allDays().map(function (d) {
                                  var beginningOfWeek = d.getDay() === 0;
                                  var beginningOfMonth = d.getDate() === 1;
                                  var beginningOfYear = DateFns.getDayOfYear(d) === 1;
                                  var hasEntry = Math.random() > 0.5;
                                  var year = d.getFullYear();
                                  var month = Core__Option.getOr(Core__Int.fromString(DateFns.format(d, "M"), undefined), 0);
                                  var monthDay = Core__Option.getOr(Core__Int.fromString(DateFns.format(d, "dd"), undefined), 0);
                                  var monthColor$1 = monthColor(month, year);
                                  var monthColorDim$1 = monthColorDim(month, year);
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
                                                false && beginningOfMonth ? JsxRuntime.jsx("div", {
                                                        children: JsxRuntime.jsx("div", {
                                                              className: ["h-px w-full -translate-y-1/2"].join(" "),
                                                              style: {
                                                                backgroundColor: monthColor$1
                                                              }
                                                            }),
                                                        className: "relative h-0 "
                                                      }) : null,
                                                false && beginningOfWeek ? JsxRuntime.jsx("div", {
                                                        children: JsxRuntime.jsx("div", {
                                                              children: "Week " + DateFns.format(d, "w"),
                                                              className: "text-sm absolute text-neutral-500 bg-black px-4 right-0 -translate-y-1/2 overflow-visible text-nowrap text-end "
                                                            }),
                                                        className: "relative h-0"
                                                      }) : null,
                                                false && beginningOfMonth ? JsxRuntime.jsx("div", {
                                                        children: JsxRuntime.jsx("div", {
                                                              children: DateFns.format(d, "MMMM"),
                                                              className: "text-sm absolute  bg-black px-4 right-1/4 -translate-y-1/2 overflow-visible text-nowrap ",
                                                              style: {
                                                                color: monthColor$1
                                                              }
                                                            }),
                                                        className: "relative h-0"
                                                      }) : null,
                                                JsxRuntime.jsxs("div", {
                                                      children: [
                                                        JsxRuntime.jsxs("div", {
                                                              children: [
                                                                true && beginningOfWeek ? JsxRuntime.jsx("div", {
                                                                        children: DateFns.format(d, "w"),
                                                                        className: "text-xs text-neutral-200 text-left  overflow-visible text-nowrap p-1"
                                                                      }) : null,
                                                                false && beginningOfMonth ? JsxRuntime.jsx("div", {
                                                                        children: DateFns.format(d, "MMM"),
                                                                        className: "text-left text-xs overflow-visible text-nowrap p-1",
                                                                        style: {
                                                                          color: monthColor$1
                                                                        }
                                                                      }) : null,
                                                                false && beginningOfYear ? JsxRuntime.jsx("div", {
                                                                        children: DateFns.format(d, "y"),
                                                                        className: "text-xs text-white text-left  overflow-visible text-nowrap p-1"
                                                                      }) : null,
                                                                false && month === 3 && monthDay === 1 ? JsxRuntime.jsx(Lu.LuFlower, {
                                                                        className: "m-1",
                                                                        style: {
                                                                          color: monthColor$1
                                                                        }
                                                                      }) : null
                                                              ],
                                                              className: " h-6 w-5 flex flex-row"
                                                            }),
                                                        JsxRuntime.jsx("div", {
                                                              className: ["w-3 h-6 "].join(" "),
                                                              style: {
                                                                backgroundColor: monthColor$1
                                                              }
                                                            }),
                                                        JsxRuntime.jsx("div", {
                                                              children: DateFns.format(d, "y-MM-dd eee"),
                                                              className: [
                                                                  "px-2",
                                                                  isToday ? "border-r-4 border-white" : ""
                                                                ].join(" "),
                                                              style: {
                                                                color: hasEntry ? monthColor$1 : monthColorDim$1
                                                              }
                                                            }),
                                                        JsxRuntime.jsx("div", {
                                                              children: "Singapore",
                                                              className: "text-neutral-500"
                                                            })
                                                      ],
                                                      className: "flex flex-row items-center gap-1"
                                                    })
                                              ]
                                            });
                                }),
                            className: "w-fit"
                          })
                    ],
                    className: "flex flex-row"
                  }),
              className: "p-6 font-mono"
            });
}

var make = App;

export {
  make ,
}
/* react Not a pure module */
