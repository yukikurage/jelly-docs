import { marked } from "marked";
import hljs from "highlight.js/lib/core";
import javascript from "highlight.js/lib/languages/javascript";
import haskell from "highlight.js/lib/languages/haskell";
import xml from "highlight.js/lib/languages/xml";

hljs.registerLanguage("javascript", javascript);
hljs.registerLanguage("haskell", haskell);
hljs.registerLanguage("purescript", haskell);
hljs.registerLanguage("xml", xml);
hljs.registerLanguage("html", xml);

marked.setOptions({
  breaks: true,
  langPrefix: "",
  highlight: (code, lang) => {
    return hljs.highlightAuto(code, [lang]).value;
  },
});

export const parseMarkdown = (markdown) => marked.parse(markdown);
