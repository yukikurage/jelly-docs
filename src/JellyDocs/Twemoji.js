import twemoji from "twemoji";

export const parseEmoji = (el) => () => {twemoji.parse(el, {folder: "svg", ext: ".svg"})};
