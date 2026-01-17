// ==========================================================
// ==========================================================
// TRADUCCIÓN - gtranslate.io

window.gtranslateSettings = {"default_language":"es","native_language_names":true,"detect_browser_language":true,"languages":["es","de","gl","en","ru"],"wrapper_selector":".gtranslate_wrapper","flag_size":24}

function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'es',
        includedLanguages: 'en,es,gl,de',
        layout: google.translate.TranslateElement.InlineLayout.HORIZONTAL
    }, 'google_translate_element');
}

function translatePage(language) {
    var iframe = document.querySelector('iframe.goog-te-menu-frame');
    if (iframe) {
        var iframeDocument = iframe.contentDocument || iframe.contentWindow.document;
        var langSelector = iframeDocument.querySelector('.goog-te-menu2-item span.text:contains("' + language + '")');
        if (langSelector) {
            langSelector.click();
        }
    }
}
function waitForTranslate() {
    var interval = setInterval(function() {
        var iframe = document.querySelector('iframe.goog-te-menu-frame');
        if (iframe) {
            clearInterval(interval);
            document.getElementById('google_translate_element').style.display = 'none';
        }
    }, 500);
}
document.addEventListener('DOMContentLoaded', waitForTranslate);

// ==========================================================
// ==========================================================
// Añadir el contenido de gpg key al <object> mediante HTML
// para que coja el color blanco del texto en todos los 
// navegadores

function anadir_texto_gpg() {
    fetch('../key.txt')
    .then(r => r.text())
    .then(texto => {
        const obj = document.getElementById('visor-clave-gpg');
        if (obj) {
            obj.addEventListener('load', () => {
                const doc = obj.contentDocument || obj.contentWindow.document;
                doc.open();
                doc.write(`<html><body style="background:black; color:white; font-family:monospace; white-space:pre; padding: 10px 5px;">${texto.replace(/</g, "&lt;")}</body></html>`);
                doc.close();
            });

            obj.data = 'about:blank';
        }
    });
}

document.addEventListener('DOMContentLoaded', anadir_texto_gpg);

// ==========================================================
// ==========================================================
// Ocultar entradas del blog o enseñarlas mediante el índice

function editar_SMR() {
    const links = document.querySelectorAll('.BlogEntradas > a');

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (entradaDiv && entradaDiv.classList.contains('Color1')) {
            const currentDisplay = window.getComputedStyle(link).display;
            if (currentDisplay === 'none') {
                link.style.display = 'block';
            } else {
                link.style.display = 'none';
            }
        }
    });
}

function editar_ASIR() {
    const links = document.querySelectorAll('.BlogEntradas > a');

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (entradaDiv && entradaDiv.classList.contains('Color2')) {
            const currentDisplay = window.getComputedStyle(link).display;
            if (currentDisplay === 'none') {
                link.style.display = 'block';
            } else {
                link.style.display = 'none';
            }
        }
    });
}

function editar_personal() {
    const links = document.querySelectorAll('.BlogEntradas > a');

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (entradaDiv && entradaDiv.classList.contains('Color0')) {
            const currentDisplay = window.getComputedStyle(link).display;
            if (currentDisplay === 'none') {
                link.style.display = 'block';
            } else {
                link.style.display = 'none';
            }
        }
    });
}

// ==========================================================
// ==========================================================

document.addEventListener('DOMContentLoaded', () => {
  const sticky = document.querySelector('.menu_bar');
  const stickyTop = sticky.offsetTop;

  const checkSticky = () => {
    if (window.scrollY >= stickyTop) {
      sticky.classList.add('menu_bar_activo');
    } else {
      sticky.classList.remove('menu_bar_activo');
    }
  };

  checkSticky();
  window.addEventListener('scroll', checkSticky);
});

// ==========================================================
// ==========================================================
// Para colapsar el menú

document.addEventListener('DOMContentLoaded', function() {
    const toggle = document.querySelector('.menu_toggle');
    const menuBar = document.querySelector('.menu_bar');

    toggle.addEventListener('click', function() {
        menuBar.classList.toggle('active');
    });
});

// ==========================================================
// ==========================================================
// Hover por palabra en los títulos

document.addEventListener('DOMContentLoaded', function() {
    const var1 = document.querySelectorAll("#proyectoH2Separar");
    var1.forEach(elemento => {
        const palabras = elemento.innerText.split(" ");
        elemento.innerHTML = palabras.map(p => `<span>${p}</span>`).join(" ");
    });
});

// ==========================================================
// ==========================================================