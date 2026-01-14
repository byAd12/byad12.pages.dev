// ==========================================================
// ==========================================================
// CAMBIAR ESTILOS DE .menu_bar

document.addEventListener("scroll", () => {
    const stickyElement = document.getElementById("menu_bar");
    const isAtTop = stickyElement.getBoundingClientRect().top === 0;

    if (isAtTop) {
        stickyElement.classList.add("menu_bar_top");
    } else {
        stickyElement.classList.remove("menu_bar_top");
    }
});

document.addEventListener("scroll", () => {
    const stickyElement = document.getElementById("dd");
    const isAtTop = stickyElement.getBoundingClientRect().top === 0;

    if (isAtTop) {
        document.getElementById("menu_bar").classList.add("menu_bar_top_2");
    } else {
        document.getElementById("menu_bar").classList.remove("menu_bar_top_2");
    }
});

// ==========================================================
// ==========================================================
// OCULTAR TODOS LOS BOTONES Y MENÚS

function esconder() {
    document.getElementById("menu_bar").style.display = "none";
    document.getElementById("gtranslate_wrapper").style.display = "none";
}

// ==========================================================
// ==========================================================
// COPIAR CONTENIDO DE .codigo

const elementosCodigo = document.querySelectorAll('.codigo');

elementosCodigo.forEach(elemento => {
  // Guardar SOLO el texto del código
  const codigoTexto = elemento.innerText;

  elemento.style.position = 'relative';

  const botonCopiar = document.createElement('span');
  botonCopiar.innerHTML = '📋';
  botonCopiar.title = 'Copiar / Copy';

  Object.assign(botonCopiar.style, {position: 'absolute', top: '8px', right: '8px', cursor: 'pointer', opacity: '0', transition: 'opacity 0.2s ease', userSelect: 'none', fontSize: '16px'} );

  elemento.appendChild(botonCopiar);
  elemento.addEventListener('mouseenter', () => { botonCopiar.style.opacity = '1'; });
  elemento.addEventListener('mouseleave', () => { botonCopiar.style.opacity = '0'; });

  botonCopiar.addEventListener('click', (e) => {
    e.stopPropagation();

    navigator.clipboard.writeText(codigoTexto)
      .then(() => {
        elemento.style.borderRadius = '5px';
        elemento.style.borderLeftColor = '#7cfb2d';

        setTimeout(() => {
          elemento.style.borderRadius = '0px';
          elemento.style.borderLeftColor = '';
        }, 250);
      })
      .catch(err => {
        console.error("Error al copiar al portapapeles", err);
      });
  });
});


// ==========================================================
// ==========================================================
// Cambiar el color de body

let originalColors = new Map();
let body = document.body;
let input = document.getElementById("NavColorCambiar2");

function aplicarColor(c){
    let r = parseInt(c.substring(1,3),16),
        g = parseInt(c.substring(3,5),16),
        b = parseInt(c.substring(5,7),16);
    let brillo = r*0.299 + g*0.587 + b*0.114;
    body.style.backgroundColor = c;
    body.querySelectorAll("*:not(.codigo, pre, code, code *, .menu_bar *)").forEach(e=>{
        if(!originalColors.has(e)) originalColors.set(e,getComputedStyle(e).color);
        e.style.color = brillo < 50 ? originalColors.get(e) : (brillo>128?"black":"white");
    });
    localStorage.setItem("navColor", c);
}

input.addEventListener("input", ()=>aplicarColor(input.value));

let c = localStorage.getItem("navColor");
if(c){ input.value=c; aplicarColor(c); }

// ==========================================================
// ==========================================================
// Para el carrusel de FTP

let indices = { server: 0, cliente: 0 };
let carruselActivo = null;

function moverImagenes(direccion, carrusel = null) {
    const carruseles = carrusel ? [carrusel] : ["server", "cliente"];
    carruseles.forEach(c => {
        const imagenes = document.getElementById(`carrusel_imagenes-${c}`);
        const totalImagenes = imagenes.querySelectorAll(".carrusel_imagen").length;
        indices[c] = (indices[c] + direccion + totalImagenes) % totalImagenes;
        imagenes.style.transform = `translateX(${-indices[c] * 100}%)`;
    });
}

function agrandarImagen(imagen) {
    const fondo = document.getElementById("fondo-agrandado");
    fondo.style.display = "block";
    carruselActivo = imagen.closest(".carrusel_imagenes").id.replace("carrusel_imagenes-", "");

    const imagenAgrandada = document.createElement("img");
    imagenAgrandada.classList.add("carrusel_imagen-agrandada");
    imagenAgrandada.src = imagen.src;
    imagenAgrandada.onclick = cerrarImagen;
    document.body.appendChild(imagenAgrandada);

    const imagenes = document.querySelectorAll(`#imagenes-${carruselActivo} .imagen`);
    indices[carruselActivo] = Array.from(imagenes).indexOf(imagen);
}

function cerrarImagen() {
    const fondo = document.getElementById("fondo-agrandado");
    fondo.style.display = "none";
    document.querySelector(".carrusel_imagen-agrandada")?.remove();
    carruselActivo = null;
}

document.addEventListener("keydown", e => {
    if (carruselActivo) {
        if (e.key === "ArrowLeft") moverImagenEnAgrandado(-1);
        if (e.key === "ArrowRight") moverImagenEnAgrandado(1);
    } else {
        if (e.key === "ArrowLeft") moverImagenes(-1);
        if (e.key === "ArrowRight") moverImagenes(1);
    }
});

function moverImagenEnAgrandado(direccion) {
    const imagenes = document.querySelectorAll(`#carrusel_imagenes-${carruselActivo} .carrusel_imagen`);
    const totalImagenes = imagenes.length;

    indices[carruselActivo] = (indices[carruselActivo] + direccion + totalImagenes) % totalImagenes;
    const nuevaImagen = imagenes[indices[carruselActivo]];

    const imagenAgrandada = document.querySelector(".carrusel_imagen-agrandada");
    if (imagenAgrandada) imagenAgrandada.src = nuevaImagen.src;
}

// ==========================================================
// ==========================================================