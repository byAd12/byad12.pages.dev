// Por byAd12.pages.dev

// ==========================================================
// ==========================================================
// MÓDULO PARA ".menu_bar"

(function() {
    const scriptSrc = document.currentScript.getAttribute("src");
    const basePath = scriptSrc.replace("resources/menu_bar.js", "");
    
    const menuHTML = `
        <div id="scroll-sentinel" style="height: 1px; width: 100%; pointer-events: none;"></div>
        <div class="menu_bar" id="menu_bar">
            <ul class="Principal">
                <li class="logo" translate="no"><a href="${basePath}index.html">by<span>Ad</span>12</a> / <a href="${basePath}guides.html">guides</a></li>
            </ul>
            <ul>
                <li><div class="gtranslate_wrapper"></div></li>
                <li><button onclick="ocultar()">Ocultar menú</button></li>
                <li><button onclick="compartir()">Compartir en PDF</button></li>
                <li><input type="color" class="NavColorCambiar" id="NavColorCambiar2" value="#222523"></li>
            </ul>
        </div>
    `;

    document.currentScript.insertAdjacentHTML("beforebegin", menuHTML);
})();

// ==========================================================
// ==========================================================
