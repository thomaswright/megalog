export function setCSSRuleProps(ruleSet) {
  const styleSheet = document.styleSheets[0];

  const rules = styleSheet.cssRules || styleSheet.rules;

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
