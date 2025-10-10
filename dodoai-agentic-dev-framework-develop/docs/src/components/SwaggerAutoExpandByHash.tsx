import { useEffect } from "react";

export default function SwaggerAutoExpandByHash() {
  useEffect(() => {
    const rawHash = window.location.hash ? window.location.hash.replace(/^#/, "") : null;
    if (!rawHash) return;

    // 1. decodeURIComponent で %2F を含む場合も含めて処理
    // 2. \/ を \\ にエスケープ（getElementById 用）
    const finalId = decodeURIComponent(rawHash).replace(/\//g, '\\/');


    const tryScrollAndExpand = (retryCount = 10) => {
      const target = document.getElementById(finalId);
      if (target) {
        // スクロール
        target.scrollIntoView({ behavior: "smooth" });

        // 展開（閉じている場合のみ）
        const parent = target.closest(".opblock");
        const button = parent?.querySelector(
          ".opblock-summary-control"
        ) as HTMLButtonElement;
        if (button && button.getAttribute("aria-expanded") === "false") {
          button.click();
        }
      } else if (retryCount > 0) {
        // 少し待って再試行（100ms後）5
        setTimeout(() => tryScrollAndExpand(retryCount - 1), 100);
      }
    };

    tryScrollAndExpand();
  }, []);

  return null;
}
