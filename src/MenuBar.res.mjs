// Generated by ReScript, PLEASE EDIT WITH CARE

import DropdownJsx from "./Dropdown.jsx";
import * as Tb from "react-icons/tb";
import * as JsxRuntime from "react/jsx-runtime";

var make = DropdownJsx;

var Dropdown = {
  make: make
};

function MenuBar(props) {
  var setTheme = props.setTheme;
  var onUnlock = props.onUnlock;
  var onLock = props.onLock;
  var onHide = props.onHide;
  var onShow = props.onShow;
  var onExportFolder = props.onExportFolder;
  var onExportFile = props.onExportFile;
  var onSort = props.onSort;
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("button", {
                      children: "Sort",
                      onClick: (function (param) {
                          onSort();
                        })
                    }),
                JsxRuntime.jsx("button", {
                      children: "Export as File",
                      onClick: (function (param) {
                          onExportFile();
                        })
                    }),
                JsxRuntime.jsx("button", {
                      children: "Export as Folder",
                      onClick: (function (param) {
                          onExportFolder();
                        })
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx("button", {
                              children: JsxRuntime.jsx(Tb.TbEye, {}),
                              onClick: (function (param) {
                                  onShow();
                                })
                            }),
                        JsxRuntime.jsx("button", {
                              children: JsxRuntime.jsx(Tb.TbEyeClosed, {}),
                              onClick: (function (param) {
                                  onHide();
                                })
                            }),
                        JsxRuntime.jsx("button", {
                              children: JsxRuntime.jsx(Tb.TbLock, {}),
                              onClick: (function (param) {
                                  onLock();
                                })
                            }),
                        JsxRuntime.jsx("button", {
                              children: JsxRuntime.jsx(Tb.TbLockOpen2, {}),
                              onClick: (function (param) {
                                  onUnlock();
                                })
                            }),
                        JsxRuntime.jsx("button", {
                              children: props.theme === "dark" ? "Dark Mode" : "Light Mode",
                              onClick: (function (param) {
                                  setTheme(function (t) {
                                        if (t === "dark") {
                                          return "light";
                                        } else {
                                          return "dark";
                                        }
                                      });
                                })
                            })
                      ],
                      className: "flex flex-row justify-around gap-6"
                    })
              ],
              className: "text-xs flex-none border-t border-[--foreground-300] flex flex-row gap-6 items-center px-2 py-1"
            });
}

var make$1 = MenuBar;

export {
  Dropdown ,
  make$1 as make,
}
/* make Not a pure module */
