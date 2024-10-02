// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Theme from "./Theme.res.mjs";
import * as React from "react";
import * as Common from "./Common.res.mjs";
import * as Global from "./Global.res.mjs";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as DateFns from "date-fns";
import * as DateDerived from "./DateDerived.res.mjs";
import MonacoJsx from "./Monaco.jsx";
import * as Core__Option from "@rescript/core/src/Core__Option.res.mjs";
import * as Tb from "react-icons/tb";
import * as JsxRuntime from "react/jsx-runtime";
import ReactTextareaAutosize from "react-textarea-autosize";

function dateToEntryDate(d) {
  var year = d.getFullYear();
  var month = d.getMonth() + 1 | 0;
  var monthDay = d.getDate();
  return {
          TAG: "Date",
          _0: year,
          _1: month,
          _2: monthDay
        };
}

function entryDateString(date) {
  switch (date.TAG) {
    case "Year" :
        return date._0.toString().padStart(4, "0");
    case "Quarter" :
        return date._0.toString().padStart(4, "0") + "-Q" + date._1.toString();
    case "Month" :
        return date._0.toString().padStart(4, "0") + "-" + date._1.toString().padStart(2, "0");
    case "Week" :
        return date._0.toString().padStart(4, "0") + "-W" + date._1.toString();
    case "Date" :
        return DateFns.format(new Date(date._0, date._1 - 1 | 0, date._2), Common.standardDateFormat);
    
  }
}

function entryClassNameId(entryDate) {
  return Core__Option.mapOr(entryDate, "", (function (date) {
                return "entryview-" + entryDateString(date);
              }));
}

var make = MonacoJsx;

var Monaco = {
  make: make
};

var TextareaAutosize = {};

function Entry$TextArea(props) {
  var __disabled = props.disabled;
  var __readonly = props.readonly;
  var __className = props.className;
  var onChange = props.onChange;
  var className = __className !== undefined ? __className : "";
  var readonly = __readonly !== undefined ? __readonly : false;
  var disabled = __disabled !== undefined ? __disabled : false;
  return JsxRuntime.jsx(ReactTextareaAutosize, {
              value: props.content,
              className: [
                  "w-full bg-transparent",
                  className
                ].join(" "),
              onChange: (function (e) {
                  var value = e.target.value;
                  onChange(value);
                }),
              readOnly: readonly,
              disabled: disabled
            });
}

var TextArea = {
  make: Entry$TextArea
};

function Entry$Entry(props) {
  var deleteEntry = props.deleteEntry;
  var isSelectedForSet = props.isSelectedForSet;
  var setEntryToSet = props.setEntryToSet;
  var updateEntry = props.updateEntry;
  var entry = props.entry;
  var monthColor = Core__Option.mapOr(entry.date, "#fff", (function (date) {
          switch (date.TAG) {
            case "Year" :
            case "Quarter" :
                return "#fff";
            case "Week" :
                return Theme.monthVar(DateDerived.getMonthForWeekOfYear(date._1, date._0));
            case "Month" :
            case "Date" :
                return Theme.monthVar(date._1);
            
          }
        }));
  var dateDisplay = Core__Option.flatMap(entry.date, (function (date) {
          if (date.TAG === "Date") {
            return DateFns.format(new Date(date._0, date._1 - 1 | 0, date._2), "y-MM-dd eee");
          } else {
            return entryDateString(date);
          }
        }));
  var goToDay = function () {
    Core__Option.mapOr(entry.date, undefined, (function (entryDate) {
            var dayMatch;
            switch (entryDate.TAG) {
              case "Year" :
                  dayMatch = {
                    TAG: "Date",
                    _0: entryDate._0,
                    _1: 0,
                    _2: 1
                  };
                  break;
              case "Quarter" :
                  dayMatch = {
                    TAG: "Date",
                    _0: entryDate._0,
                    _1: entryDate._1 - 3 | 0,
                    _2: 1
                  };
                  break;
              case "Month" :
                  dayMatch = {
                    TAG: "Date",
                    _0: entryDate._0,
                    _1: entryDate._1,
                    _2: 1
                  };
                  break;
              case "Week" :
                  dayMatch = {
                    TAG: "Week",
                    _0: entryDate._0,
                    _1: entryDate._1
                  };
                  break;
              case "Date" :
                  dayMatch = {
                    TAG: "Date",
                    _0: entryDate._0,
                    _1: entryDate._1,
                    _2: entryDate._2
                  };
                  break;
              
            }
            Core__Option.mapOr(Global.Derived.getElementByIdOp("dayview-" + entryDateString(dayMatch)), undefined, (function (element) {
                    element.scrollIntoView({
                          behavior: "smooth",
                          block: "center"
                        });
                  }));
            var monthMatch;
            switch (entryDate.TAG) {
              case "Year" :
                  monthMatch = {
                    TAG: "Year",
                    _0: entryDate._0
                  };
                  break;
              case "Quarter" :
                  monthMatch = {
                    TAG: "Quarter",
                    _0: entryDate._0,
                    _1: entryDate._1
                  };
                  break;
              case "Week" :
                  var y = entryDate._0;
                  monthMatch = {
                    TAG: "Month",
                    _0: y,
                    _1: DateDerived.getMonthForWeekOfYear(entryDate._1, y)
                  };
                  break;
              case "Month" :
              case "Date" :
                  monthMatch = {
                    TAG: "Month",
                    _0: entryDate._0,
                    _1: entryDate._1
                  };
                  break;
              
            }
            Core__Option.mapOr(Global.Derived.getElementByClassOp("monthview-" + entryDateString(monthMatch)), undefined, (function (element) {
                    element.scrollIntoView({
                          behavior: "smooth",
                          block: "center"
                        });
                  }));
          }));
  };
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsxs("div", {
                      children: [
                        Core__Option.mapOr(dateDisplay, null, (function (dateDisplay_) {
                                return JsxRuntime.jsx("span", {
                                            children: dateDisplay_,
                                            className: "cursor-pointer mr-2 font-black",
                                            style: {
                                              backgroundColor: isSelectedForSet ? monthColor : "transparent",
                                              color: isSelectedForSet ? "black" : monthColor
                                            },
                                            onClick: (function (param) {
                                                if (isSelectedForSet) {
                                                  return setEntryToSet(function (param) {
                                                              
                                                            });
                                                } else {
                                                  return goToDay();
                                                }
                                              })
                                          });
                              })),
                        JsxRuntime.jsx("input", {
                              className: "flex-1 bg-inherit text-white min-w-8 italic font-light outline-none leading-none padding-none border-none h-5 -my-1",
                              placeholder: "",
                              readOnly: entry.lock,
                              type: "text",
                              value: entry.title,
                              onChange: (function (e) {
                                  updateEntry(entry.id, (function (v) {
                                          return {
                                                  id: v.id,
                                                  date: v.date,
                                                  title: e.target.value,
                                                  content: v.content,
                                                  lock: v.lock,
                                                  hide: v.hide
                                                };
                                        }));
                                })
                            }),
                        JsxRuntime.jsx("span", {
                              className: "flex-none w-4"
                            }),
                        JsxRuntime.jsx("span", {
                              children: entry.lock ? JsxRuntime.jsx("button", {
                                      children: JsxRuntime.jsx(Tb.TbLock, {}),
                                      className: [
                                          "mx-1",
                                          " text-plain-500"
                                        ].join(" "),
                                      onClick: (function (param) {
                                          updateEntry(entry.id, (function (v) {
                                                  return {
                                                          id: v.id,
                                                          date: v.date,
                                                          title: v.title,
                                                          content: v.content,
                                                          lock: false,
                                                          hide: v.hide
                                                        };
                                                }));
                                        })
                                    }) : JsxRuntime.jsxs(React.Fragment, {
                                      children: [
                                        JsxRuntime.jsx("button", {
                                              children: isSelectedForSet ? "Cancel" : "Pick Date",
                                              className: ["mx-1 "].join(" "),
                                              style: {
                                                backgroundColor: isSelectedForSet ? monthColor : "white",
                                                color: "black"
                                              },
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
                                              children: "Delete",
                                              className: [
                                                  "mx-1",
                                                  "bg-white text-black"
                                                ].join(" "),
                                              onClick: (function (param) {
                                                  deleteEntry(entry.id);
                                                })
                                            }),
                                        JsxRuntime.jsx("button", {
                                              children: entry.hide ? "Show" : "Hide",
                                              className: [
                                                  "mx-1",
                                                  "bg-white text-black"
                                                ].join(" "),
                                              onClick: (function (param) {
                                                  updateEntry(entry.id, (function (v) {
                                                          return {
                                                                  id: v.id,
                                                                  date: v.date,
                                                                  title: v.title,
                                                                  content: v.content,
                                                                  lock: v.lock,
                                                                  hide: !v.hide
                                                                };
                                                        }));
                                                })
                                            }),
                                        JsxRuntime.jsx("button", {
                                              children: JsxRuntime.jsx(Tb.TbLockOpen2, {}),
                                              className: [
                                                  "mx-1",
                                                  " text-plain-500"
                                                ].join(" "),
                                              onClick: (function (param) {
                                                  updateEntry(entry.id, (function (v) {
                                                          return {
                                                                  id: v.id,
                                                                  date: v.date,
                                                                  title: v.title,
                                                                  content: v.content,
                                                                  lock: true,
                                                                  hide: v.hide
                                                                };
                                                        }));
                                                })
                                            })
                                      ]
                                    }),
                              className: "flex flex-row items-center"
                            })
                      ],
                      className: [
                          entryClassNameId(entry.date),
                          "heading py-2 border-b flex flex-row items-center pr-4"
                        ].join(" "),
                      style: {
                        borderColor: monthColor,
                        color: monthColor
                      }
                    }),
                JsxRuntime.jsx("div", {
                      children: JsxRuntime.jsx("div", {
                            children: entry.hide ? null : JsxRuntime.jsx(Entry$TextArea, {
                                    content: entry.content,
                                    onChange: (function (newContent) {
                                        updateEntry(entry.id, (function (v) {
                                                return {
                                                        id: v.id,
                                                        date: v.date,
                                                        title: v.title,
                                                        content: newContent,
                                                        lock: v.lock,
                                                        hide: v.hide
                                                      };
                                              }));
                                      }),
                                    className: [
                                        "editor scroll-m-20 ",
                                        entry.hide ? "text-transparent select-none" : ""
                                      ].join(" "),
                                    readonly: entry.lock,
                                    disabled: entry.hide
                                  }),
                            className: "rounded overflow-hidden"
                          }),
                      className: "py-2"
                    })
              ]
            }, entry.id);
}

var make$1 = React.memo(Entry$Entry, (function (a, b) {
        var match = a.entry.date;
        var match$1 = b.entry.date;
        if ((
            match !== undefined ? (
                match$1 !== undefined ? entryDateString(match) === entryDateString(match$1) : false
              ) : match$1 === undefined
          ) && a.entry.content === b.entry.content && a.entry.lock === b.entry.lock && a.entry.hide === b.entry.hide && a.entry.title === b.entry.title) {
          return a.isSelectedForSet === b.isSelectedForSet;
        } else {
          return false;
        }
      }));

var Entry = {
  make: make$1
};

function Entry$Entries(props) {
  var deleteEntry = props.deleteEntry;
  var entryToSet = props.entryToSet;
  var setEntryToSet = props.setEntryToSet;
  var updateEntry = props.updateEntry;
  return JsxRuntime.jsx("div", {
              children: Core__Option.mapOr(props.entries, null, (function (entries_) {
                      return entries_.map(function (entry) {
                                  var isSelectedForSet = Core__Option.mapOr(entryToSet, false, (function (v) {
                                          return v === entry.id;
                                        }));
                                  return JsxRuntime.jsx(make$1, {
                                              entry: entry,
                                              updateEntry: updateEntry,
                                              setEntryToSet: setEntryToSet,
                                              isSelectedForSet: isSelectedForSet,
                                              deleteEntry: deleteEntry
                                            }, entry.id);
                                });
                    })),
              className: "text-xs leading-none flex-1 h-full overflow-y-scroll max-w-xl"
            });
}

var Entries = {
  make: Entry$Entries
};

var Editor;

export {
  dateToEntryDate ,
  entryDateString ,
  entryClassNameId ,
  Monaco ,
  TextareaAutosize ,
  TextArea ,
  Editor ,
  Entry ,
  Entries ,
}
/* make Not a pure module */
