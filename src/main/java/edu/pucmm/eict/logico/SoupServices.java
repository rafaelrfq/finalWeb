package edu.pucmm.eict.logico;

import edu.pucmm.eict.controladora.FormularioServicios;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Ejemplo de servicio patron Singleton
 */
public class SoupServices {

    private static SoupServices instancia;


    /**
     * Constructor privado.
     */
    private SoupServices(){


    }

    public static SoupServices getInstancia(){
        if(instancia==null){
            instancia = new SoupServices();
        }
        return instancia;
    }

    /**
     * Permite autenticar los usuarios. Lo ideal es sacar en
     * @param usuario
     * @param password
     * @return
     */
    public Usuario autheticarUsuario(String usuario, String password){
        //simulando la busqueda en la base de datos.
        return new Usuario(usuario, "Usuario "+usuario, password);
    }



    public List<Formulario> listarFormulario(){
        return FormularioServicios.getInstance().ListadoCompleto();
    }

    public Formulario getFormulario(int id){
        return FormularioServicios.getInstance().find(id);
    }

    public Formulario crearFormulario(Formulario formulario){

        FormularioServicios.getInstance().crear(formulario);
        return formulario;
    }

    public Formulario actualizarFormulario(Formulario formulario){
        if (FormularioServicios.getInstance().editar(formulario)){
            return formulario;
        }

        return null;
    }

    public boolean eliminandoFormulario(int id){
        return FormularioServicios.getInstance().eliminar(id);
    }

}
