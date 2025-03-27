import RefreshRuntime from "/@react-refresh";

const urlParams = new URLSearchParams(window.location.search);
const isEmbedded = urlParams.has("shop");

console.log("Is app embedded in Shopify?", isEmbedded);
console.log("Parent window:", window.parent);
console.log("Current window:", window.self);

RefreshRuntime.injectIntoGlobalHook(window);
window.$RefreshReg$ = () => {};
window.$RefreshSig$ = () => (type) => type;
window.__vite_plugin_react_preamble_installed__ = true;
