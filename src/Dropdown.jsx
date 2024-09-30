import React from "react";
import * as DropdownMenu from "@radix-ui/react-dropdown-menu";
import {
  TbChevronDown,
  TbEye,
  TbEyeClosed,
  TbLock,
  TbLockOpen,
} from "react-icons/tb";
import "./dropdown.css";

const Dropdown = ({
  onSort,
  onExportFile,
  onExportFolder,
  onShow,
  onHide,
  onLock,
  onUnlock,
}) => {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger asChild>
        <button className="IconButton" aria-label="Customise options">
          <TbChevronDown />
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
              <TbLockOpen />
            </DropdownMenu.Item>
          </div>

          <DropdownMenu.Arrow className="DropdownMenuArrow" />
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu.Root>
  );
};

export default Dropdown;
