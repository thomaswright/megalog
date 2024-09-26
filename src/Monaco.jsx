import React, { useEffect, useRef } from "react";
import Editor, { useMonaco } from "@monaco-editor/react";

function Main({ content }) {
  let containerRef = useRef(null);
  const updateHeight = (editor) => {
    const contentHeight = Math.min(1000, editor.getContentHeight());

    editor.layout({
      width: containerRef.current.offsetWidth,
      height: contentHeight,
    });
  };

  const onMount = (editor, monaco) => {
    editor.onDidContentSizeChange(() => updateHeight(editor));
  };

  return (
    <div ref={containerRef}>
      <Editor
        defaultValue={content}
        defaultLanguage="markdown"
        onMount={onMount}
        options={{
          theme: "vs-dark",
          wordWrap: "on",
          minimap: {
            enabled: false,
          },
          lineNumbers: "off",
          glyphMargin: false,
          folding: false,
          // Undocumented see https://github.com/Microsoft/vscode/issues/30795#issuecomment-410998882
          lineDecorationsWidth: 8,
          lineNumbersMinChars: 0,
          renderLineHighlight: "none",
          scrollBeyondLastLine: false,
          scrollbar: {
            vertical: "hidden",
            alwaysConsumeMouseWheel: false,
          },
        }}
      />
    </div>
  );
}

export default Main;
