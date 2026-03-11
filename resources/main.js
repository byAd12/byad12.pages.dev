// Por byAd12.pages.dev

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
    const boton = document.getElementById("editar_SMR");

    let algunoVisible = false;

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (!entradaDiv || !entradaDiv.classList.contains('Color1')) return;

        link.classList.toggle('oculto');

        if (!link.classList.contains('oculto')) {
            algunoVisible = true;
        }
    });

    if (algunoVisible) {
        boton.style.textDecoration = "none";
        boton.style.color = "white";
    } else {
        boton.style.textDecoration = "line-through";
        boton.style.color = "rgb(228, 196, 196)";
    }
}

function editar_ASIR() {
    const links = document.querySelectorAll('.BlogEntradas > a');
    const boton = document.getElementById("editar_ASIR");

    let algunoVisible = false;

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (!entradaDiv || !entradaDiv.classList.contains('Color2')) return;

        link.classList.toggle('oculto');

        if (!link.classList.contains('oculto')) {
            algunoVisible = true;
        }
    });

    if (algunoVisible) {
        boton.style.textDecoration = "none";
        boton.style.color = "white";
    } else {
        boton.style.textDecoration = "line-through";
        boton.style.color = "rgb(228, 196, 196)";
    }
}

function editar_personal() {
    const links = document.querySelectorAll('.BlogEntradas > a');
    const boton = document.getElementById("editar_personal");

    let algunoVisible = false;

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (!entradaDiv || !entradaDiv.classList.contains('Color0')) return;

        link.classList.toggle('oculto');

        if (!link.classList.contains('oculto')) {
            algunoVisible = true;
        }
    });

    if (algunoVisible) {
        boton.style.textDecoration = "none";
        boton.style.color = "white";
    } else {
        boton.style.textDecoration = "line-through";
        boton.style.color = "rgb(228, 196, 196)";
    }
}

function editar_boton_filtros_avanzados() {
    const links = document.querySelectorAll('.filtro_boton');
    const ocultarExpandido = document.querySelectorAll('.filtro_boton_ocultar_expandido');
    const boton = document.getElementById("editar_boton_filtros_avanzados");

    const filtrosYaVisibles = Array.from(links).some(link => !link.classList.contains('oculto'));

    if (!filtrosYaVisibles) {
        resetearFiltrosYEstilos();
        links.forEach(link => link.classList.remove('oculto'));
        ocultarExpandido.forEach(link => link.classList.add('oculto'));
        boton.style.color = "#7cfb2d";
    } else {
        links.forEach(link => link.classList.add('oculto'));
        ocultarExpandido.forEach(link => link.classList.remove('oculto'));
        boton.style.color = "white";
        resetearFiltrosYEstilos();
    }
}


function editar_filtro_servicio_directorio() {
    toggleFiltro('filtro_servicio_directorio', 'editar_filtro_servicio_directorio');
}

function editar_filtro_compartir_recursos() {
    toggleFiltro('filtro_compartir_recursos', 'editar_filtro_compartir_recursos');
}

function editar_filtro_lenguaje_marcas() {
    toggleFiltro('filtro_lenguaje_marcas', 'editar_filtro_lenguaje_marcas');
}

function editar_filtro_redes() {
    toggleFiltro('filtro_redes', 'editar_filtro_redes');
}

function editar_filtro_linux() {
    toggleFiltro('filtro_linux', 'editar_filtro_linux');
}

function editar_filtro_servicios_linux() {
    toggleFiltro('filtro_servicios_linux', 'editar_filtro_servicios_linux');
}

function editar_filtro_seguridad() {
    toggleFiltro('filtro_seguridad', 'editar_filtro_seguridad');
}

function toggleFiltro(claseFiltro, idBoton) {
    const links = document.querySelectorAll('.BlogEntradas > a');
    const boton = document.getElementById(idBoton);
    let algunoVisible = false;

    links.forEach(link => {
        const entradaDiv = link.querySelector('.Entrada');
        if (!entradaDiv || !entradaDiv.classList.contains(claseFiltro)) return;

        link.classList.toggle('oculto');

        if (!link.classList.contains('oculto')) {
            algunoVisible = true;
        }
    });

    if (algunoVisible) {
        boton.style.textDecoration = "none";
        boton.style.color = "white";
    } else {
        boton.style.textDecoration = "line-through";
        boton.style.color = "rgb(228, 196, 196)";
    }
}


function resetearFiltrosYEstilos() {
    document.querySelectorAll('.BlogEntradas > a').forEach(link => link.classList.remove('oculto'));

    const botonesPrincipales = [
        document.getElementById("editar_ASIR"),
        document.getElementById("editar_SMR"),
        document.getElementById("editar_personal")
    ];

    const botonesAvanzados = document.querySelectorAll('.filtro_boton');
    const todosLosBotones = [...botonesPrincipales, ...botonesAvanzados];
    
    todosLosBotones.forEach(boton => {
        if (boton) {
            boton.style.textDecoration = "none";
            boton.style.color = "white";
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
    const var1 = document.querySelectorAll(".proyectoH2Separar");
    var1.forEach(elemento => {
        const palabras = elemento.innerText.split(" ");
        elemento.innerHTML = palabras.map(p => `<span>${p}</span>`).join(" ");
    });
});

// ==========================================================
// ==========================================================
// Insertar e-mail en los enlaces

document.addEventListener('DOMContentLoaded', function() {
    const binaryString = atob('YWRnaW1lbmV6cEBnbWFpbC5jb20=');
    const bytes = new Uint8Array(binaryString.length);
    for (let i = 0; i < binaryString.length; i++) {
        bytes[i] = binaryString.charCodeAt(i);
    }
    const decoder = new TextDecoder();
    
    document.getElementById("EmailBoton").href = 'mailto:' + decoder.decode(bytes);
});

// ==========================================================
// ==========================================================
