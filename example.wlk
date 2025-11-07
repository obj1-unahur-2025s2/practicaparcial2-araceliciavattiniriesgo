class Personaje{
    var rol 
    const fuerza
    const property inteligencia 

    method cambiarRol(nuevoRol){ rol = nuevoRol }
    method rol() = rol 
    method potencialOfensivo(){ return (fuerza * 10) + rol.potencial() }
    method esInteligente()
    method esGroso() = self.esInteligente() or rol.esGroso(self)
}


class Rol{
  method rol()
}

object rolGuerrero {
  method potencial() = 100
  method brutalidadInnata(unValor) = 0
  method esGroso(unPersonaje){ return unPersonaje.fuerza() > 50 }
}

class RolCazador inherits Rol{ // rol cazador
  var mascota = new Mascota(fuerza=0,edad=0,tieneGarras=false)
  method cambiarMascota(unaMascota){ mascota = unaMascota }
  method naceNuevaMascota(fuerza,edad,tieneGarras){
    mascota = new Mascota(fuerza=fuerza,edad=edad,tieneGarras=tieneGarras)
  }
  method potencial() = mascota.potencial()
  method brutalidadInnata(unValor) = 0
  method esGroso(unPersonaje){ return mascota.esLongeva()}


}
object rolBrujo{
   method potencial() = 0
   method brutalidadInnata(unValor){
    return unValor * 0.1
  }

  method esGroso(unPersonaje) = true 
}
class Mascota {
  const tieneGarras 
  const edad 
  const fuerza 

  method edad() = edad
  method fuerza() = fuerza
  method tieneGarras() = tieneGarras
  method initialize(){ if (fuerza >= 100) { self.error("ERRORRRRR")} }
  method potencial(){ if(tieneGarras) fuerza * 2 else fuerza }
  method esLongeva(){ return edad > 10 }
}
class Orco inherits Personaje{
  override method potencialOfensivo() {
    return super() + rol.brutalidadInnata(super())
  }
  override method esInteligente() = false 
}
class Humano inherits Personaje{
  override method esInteligente() = inteligencia > 50
}
class Localidad {
  var ejercito = new Ejercito()

  method enlistar(unPersonaje){ ejercito.agregar(unPersonaje) }
  method poderDefensivo() = ejercito.potencialOfensivo()
  method serOcupada(unEjercito)
}
class Aldea inherits Localidad{
    const cantMax 
    override method enlistar(unPersonaje){
      if(ejercito.personajes().size() >= cantMax){
        self.error("Ejercito completo")
      }
      super(unPersonaje)
    }

    override method serOcupada(unEjercito){
      ejercito.clear()
      unEjercito.los10MasMejores().forEach({ p => 
        self.enlistar(p)
      })

      unEjercito.quitarLosMasMejores(cantMax.min(10))
    }
}
class CiudadRica inherits Localidad{
  override method poderDefensivo(){
    return super() + 300
  }

  override method serOcupada(unEjercito){
    ejercito = unEjercito
  }
}

class Ejercito{
  const property personajes = #{}

  method potencialOfensivo(){
    return personajes.sum({p => p.potencialOfensivo()})
  }

  method agregar(unPersonaje){
    personajes.add(unPersonaje)
  }

  method invadir(unaLocalidad){
    if (self.puedeInvadir(unaLocalidad)){
      unaLocalidad.serOcupada(self)
    }
  }

  method puedeInvadir(unaLocalidad){
    return self.potencialOfensivo() > unaLocalidad.poderDefensivo()
  }

  method los10MasMejores() = self.listaOrdenadaPorPoder().take(10)
  method listaOrdenadaPorPoder(){
    return personajes.asList().sortBy({p1,p2 => p1.potencialOfensivo() > p2.potencialOfensivo()})
  }

  method quitarLosMasMejores(cantidadAQuitar){
    personajes.removeAll(self.los10MasMejores().take(cantidadAQuitar))
  }
}

