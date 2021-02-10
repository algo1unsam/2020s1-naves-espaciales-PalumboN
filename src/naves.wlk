// Método lookup : Al enviarle un mensaje a un objeto, selecciona qué método ejecutar
// 1. object -> Busca el método en la definición del objeto
// 2. objetos instanciados -> Busca el método en la clase de la cual se instancia
// 3. Si no lo encuentra -> Busca en la superclase (repite hasta Object)
// - Si al final no encuentra nada -> Lanza MethodNotUndestoodException


class Nave {

	var property velocidad = 0

	method aumentarVelocidad(velocidadAAumentar) {
		velocidad = (velocidad + velocidadAAumentar).min(300000)
	}

	method propulsar() {
		self.aumentarVelocidad(20000)
	}

	method prepararParaViajar() {
		self.aumentarVelocidad(15000)
	}
	
	method encontrarEnemigo() {
		self.propulsar()		// General de todas las naves
		self.recibirAmenaza() 	// Particular de cada subclase
	}
	
	method recibirAmenaza() // Método abstracto (sin implementación)

}

class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}

class NaveDeResiduosRadioactivos inherits NaveDeCarga {

	var property selladaAlVacio = false

	override method recibirAmenaza() {
		velocidad = 0
	}

	override method prepararParaViajar() {
		super()
		selladaAlVacio = true
	}

}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

// HERENCIA -> Manejar el comportamiento distinto (Estática: un objeto nace y muere como tal, entonces una nave de combate nunca podrá ser una nave de pasajeros)
class NaveDeCombate inherits Nave {
	// COMPOSICIÓN -> Manejar el comportamiento distinto (Dinámica: puedo cambiar el comportamiento durante la ejecución)
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}

	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	override method prepararParaViajar() {
		super()
		modo.navePreparandoseParaViajar(self)
	}

}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	
	method navePreparandoseParaViajar(nave) {
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}

}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	
	method navePreparandoseParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}

}

