import { BrowserRouter } from "react-router-dom";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { NavMenu } from "@shopify/app-bridge-react";
import Routes from "./Routes";
import { QueryProvider, PolarisProvider } from "./components";
import createApp from "@shopify/app-bridge";

export default function App() {
  const { t } = useTranslation();
  const [app, setApp] = useState(null);
  
  useEffect(() => {
    const shopOrigin = new URLSearchParams(window.location.search).get("shop");

    if (shopOrigin) {
      const appBridge = createApp({
        apiKey: import.meta.env.VITE_SHOPIFY_API_KEY,
        shopOrigin,
      });
      setApp(appBridge);
      console.log("Shopify App Context:", appBridge);
    }
  }, []);

  const isEmbedded = window.self !== window.top;
  console.log("Is app embedded in an iframe?", isEmbedded);

  const pages = import.meta.globEager("./pages/**/!(*.test.[jt]sx)*.([jt]sx)");

  return (
    <PolarisProvider>
      <BrowserRouter>
        <QueryProvider>
          <NavMenu>
            <a href="/" rel="home" />
            <a href="/pagename">{t("NavigationMenu.pageName")}</a>
          </NavMenu>
          <Routes pages={pages} />
        </QueryProvider>
      </BrowserRouter>
    </PolarisProvider>
  );
}
