// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Entry from "./Entry.res.mjs";
import * as Theme from "./Theme.res.mjs";
import * as React from "react";
import * as Common from "./Common.res.mjs";
import * as DateFns from "date-fns";
import * as Core__Int from "@rescript/core/src/Core__Int.res.mjs";
import * as DateDerived from "./DateDerived.res.mjs";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as JsxRuntime from "react/jsx-runtime";

function Days$Day(props) {
  var entry = props.entry;
  var hasWeekEntry = props.hasWeekEntry;
  var onClick = props.onClick;
  var d = props.d;
  var beginningOfWeek = d.getDay() === 0;
  var year = d.getFullYear();
  var month = d.getMonth() + 1 | 0;
  var monthDay = d.getDate();
  var monthColor = Theme.monthVar(month);
  var monthDimColor = Theme.monthDimVar(month);
  var isToday = DateFns.isSameDay(new Date(), d);
  var tmp;
  if (beginningOfWeek) {
    var week = DateFns.format(d, "w");
    tmp = Core__Option.mapOr(Core__Int.fromString(week, undefined), null, (function (weekNum) {
            return JsxRuntime.jsx("button", {
                        children: week,
                        className: "text-left overflow-visible text-nowrap px-1 font-normal",
                        id: "dayview-" + Entry.entryDateString({
                              TAG: "Week",
                              _0: year,
                              _1: weekNum
                            }),
                        style: {
                          color: hasWeekEntry ? monthColor : "var(--foreground-700)"
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
                beginningOfWeek ? JsxRuntime.jsx("div", {
                        children: JsxRuntime.jsx("div", {
                              className: "h-px w-full absolute -translate-y-1/2",
                              style: {
                                background: monthColor
                              }
                            }),
                        className: "relative h-0 ml-px"
                      }) : null,
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("div", {
                              children: tmp,
                              className: " h-full w-5 flex flex-row flex-none items-center"
                            }),
                        JsxRuntime.jsxs("button", {
                              children: [
                                JsxRuntime.jsx("span", {
                                      className: ["w-1 h-full flex-none"].join(" "),
                                      style: {
                                        background: monthColor
                                      }
                                    }),
                                JsxRuntime.jsx("span", {
                                      children: DateFns.format(d, "y-MM-dd eee"),
                                      className: [
                                          " px-2 flex-none",
                                          isToday ? "border-r-4 border-white" : ""
                                        ].join(" "),
                                      style: {
                                        color: Core__Option.isSome(entry) ? monthColor : monthDimColor
                                      }
                                    }),
                                JsxRuntime.jsx("span", {
                                      children: Core__Option.mapOr(entry, "", (function (e) {
                                              return e.title;
                                            })),
                                      className: "font-light text-white flex-none italic"
                                    })
                              ],
                              className: "h-full flex-1 flex flex-row items-center whitespace-nowrap overflow-x-hidden",
                              id: "dayview-" + Entry.entryDateString({
                                    TAG: "Date",
                                    _0: year,
                                    _1: month,
                                    _2: monthDay
                                  }),
                              onClick: (function (param) {
                                  onClick({
                                        TAG: "Date",
                                        _0: year,
                                        _1: month,
                                        _2: monthDay
                                      });
                                })
                            })
                      ],
                      className: "text-xs font-black flex flex-row items-center gap-1 h-5 whitespace-nowrap overflow-x-hidden"
                    })
              ]
            });
}

var make = React.memo(Days$Day, (function (a, b) {
        var tmp = false;
        if (a.d.getTime() === b.d.getTime()) {
          var match = a.entry;
          var match$1 = b.entry;
          tmp = match !== undefined ? (
              match$1 !== undefined ? match.title === match$1.title : false
            ) : match$1 === undefined;
        }
        if (tmp) {
          return a.hasWeekEntry === b.hasWeekEntry;
        } else {
          return false;
        }
      }));

var Day = {
  make: make
};

function Days(props) {
  var dateEntries = props.dateEntries;
  var onClick = props.onClick;
  var dateSet = props.dateSet;
  return JsxRuntime.jsx("div", {
              children: DateDerived.allDays(props.start, props.end).map(function (d) {
                    return JsxRuntime.jsx(make, {
                                d: d,
                                onClick: onClick,
                                hasWeekEntry: dateSet.has(DateFns.format(d, "y") + "-W" + DateFns.format(d, "w")),
                                entry: dateEntries.get(DateFns.format(d, Common.standardDateFormat))
                              }, d.toString());
                  }),
              className: "w-full flex-2 overflow-y-scroll text-xs"
            });
}

var make$1 = Days;

export {
  Day ,
  make$1 as make,
}
/* make Not a pure module */
