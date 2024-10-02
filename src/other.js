export function setCSSRuleProps(ruleSet) {
  const styleSheets = document.styleSheets;

  if (styleSheets.length > 0) {
    const lastStyleSheet = styleSheets[styleSheets.length - 1];

    if (lastStyleSheet instanceof CSSStyleSheet) {
      const rules = lastStyleSheet.cssRules || lastStyleSheet.rules;

      for (let i = 0; i < rules.length; i++) {
        const rule = rules[i];

        ruleSet.forEach(([ruleMatch, properties]) => {
          if (rule.selectorText === ruleMatch) {
            properties.forEach(([name, value]) => {
              rule.style.setProperty(name, value);
            });
          }
        });
      }
    }
  }
}
