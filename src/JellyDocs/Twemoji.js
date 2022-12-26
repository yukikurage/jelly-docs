import twemoji from "twemoji";

export const parseEmoji = (el) => () => {
  twemoji.parse(el, { folder: "svg", ext: ".svg", base: 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/' });
};
