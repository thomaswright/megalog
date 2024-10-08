import React, { useRef } from "react";
import * as DropdownMenu from "@radix-ui/react-dropdown-menu";
import {
  TbChevronDown,
  TbEye,
  TbEyeClosed,
  TbLock,
  TbLockOpen2,
  TbSun,
  TbMoon,
} from "react-icons/tb";
import "./dropdown.css";

const Dropdown = ({
  onSort,
  onExportFile,
  onExportFolder,
  onExportJson,
  onImportJson,
  onShow,
  onHide,
  onLock,
  onUnlock,
  theme,
  setTheme,
}) => {
  let importJsonInputRef = useRef(null);
  return (
    <DropdownMenu.Root modal={false}>
      <DropdownMenu.Trigger asChild>
        <button className="IconButton" aria-label="Customise options">
          {"Megalog"}
        </button>
      </DropdownMenu.Trigger>

      <DropdownMenu.Portal>
        <DropdownMenu.Content className="DropdownMenuContent" sideOffset={5}>
          <DropdownMenu.Item
            key={"sort"}
            onSelect={(_) => onSort()}
            className="DropdownMenuItem"
          >
            {"Sort"}
          </DropdownMenu.Item>

          <DropdownMenu.Item
            key={"export_file"}
            onSelect={(_) => onExportFile()}
            className="DropdownMenuItem"
          >
            {"Export as File"}
          </DropdownMenu.Item>

          <DropdownMenu.Item
            key={"export_folder"}
            onSelect={(_) => onExportFolder()}
            className="DropdownMenuItem"
          >
            {"Export as Folder"}
          </DropdownMenu.Item>
          <DropdownMenu.Item
            key={"export_json"}
            onSelect={(_) => onExportJson()}
            className="DropdownMenuItem"
          >
            {"Export as JSON"}
          </DropdownMenu.Item>
          <DropdownMenu.Item
            key={"import_json"}
            onSelect={(event) => {
              event.preventDefault();
              importJsonInputRef.current.click();
            }}
            className="DropdownMenuItem"
          >
            {"Import JSON"}
          </DropdownMenu.Item>
          <input
            ref={importJsonInputRef}
            id={"jsonFileInput"}
            type="file"
            accept=".json"
            className="hidden"
            onChange={(event) => {
              const file = event.target.files[0];
              if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                  try {
                    const jsonData = JSON.parse(e.target.result);

                    onImportJson(jsonData);
                  } catch (err) {
                    output.textContent = "Error parsing JSON: " + err.message;
                  }
                };
                reader.readAsText(file);
              }
            }}
          />

          <DropdownMenu.Item
            key={"theme"}
            onSelect={(event) => {
              event.preventDefault();
              setTheme((v) => (v == "dark" ? "light" : "dark"));
            }}
            className="DropdownMenuItem"
          >
            {theme == "dark" ? (
              <div className="flex flex-row gap-2 items-center w-full ">
                <TbSun />
                <span>{"Light Mode"}</span>
              </div>
            ) : (
              <div className="flex flex-row gap-2 items-center w-full">
                <TbMoon />
                <span>{"Dark Mode"}</span>
              </div>
            )}
          </DropdownMenu.Item>
          <div className="text-xs font-medium text-[--foreground-700] pt-2 pb-1 px-2 ">
            {"Apply to all"}
          </div>
          <div className="flex flex-row justify-around">
            <DropdownMenu.Item
              key={"show"}
              onSelect={(_) => onShow()}
              className="DropdownMenuItem"
            >
              <TbEye />
            </DropdownMenu.Item>
            <DropdownMenu.Item
              key={"hide"}
              onSelect={(_) => onHide()}
              className="DropdownMenuItem"
            >
              <TbEyeClosed />
            </DropdownMenu.Item>

            <DropdownMenu.Item
              key={"lock"}
              onSelect={(_) => onLock()}
              className="DropdownMenuItem"
            >
              <TbLock />
            </DropdownMenu.Item>
            <DropdownMenu.Item
              key={"unlock"}
              onSelect={(_) => onUnlock()}
              className="DropdownMenuItem"
            >
              <TbLockOpen2 />
            </DropdownMenu.Item>
          </div>

          <DropdownMenu.Arrow className="DropdownMenuArrow" />
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu.Root>
  );
};

export default Dropdown;
