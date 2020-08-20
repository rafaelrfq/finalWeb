package edu.pucmm.eict.soap;


import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.SoupServices;


import javax.jws.WebMethod;
import javax.jws.WebService;
import java.util.List;

/**
 * Clase para implementar un servicio web basado en SOAP
 */

@WebService
public class FormularioWebServices {

    private SoupServices fakeServices = SoupServices.getInstancia();

    @WebMethod
    public String holaMundo(String hola){
        System.out.println("Ejecuntado en el servidor.");
        return "Hola Mundo "+hola+", :-D";
    }

    @WebMethod
    public String otroMetodo(String hola){
        System.out.println("Ejecuntado en el servidor.");
        return "Hola Mundo "+hola+", :-D";
    }

    @WebMethod
    public List<Formulario> getListaFormulario(){
        return fakeServices.listarFormulario();
    }

    @WebMethod
    public Formulario getFormulario(int id){
        return fakeServices.getFormulario(id);
    }

    @WebMethod
    public Formulario crearFormulario(Formulario formulario){
        return fakeServices.crearFormulario(formulario);
    }

    @WebMethod
    public Formulario actualizarFormulario(Formulario formulario){
        return fakeServices.actualizarFormulario(formulario);
    }

}
