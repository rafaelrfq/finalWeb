package edu.pucmm.eict.rutas;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.FormularioJSON;
import io.javalin.Javalin;
import org.eclipse.jetty.websocket.api.Session;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class WebSocketRutas {
    private Javalin app;
    public WebSocketRutas(Javalin app) { this.app = app; }
    public static List<Session> usuariosConectados = new ArrayList<>();
    public static List<FormularioJSON> formulariosRecibidos = new ArrayList<>();

    FormularioServicios formuInstancia = FormularioServicios.getInstance();

    public void rutas(){
        app.routes(() -> {
            app.before(ctx -> {

                for (FormularioJSON formu : formulariosRecibidos) {
                    if (formu.getNombre() != null && formu.getSector() != null && formu.getNivelEscolar() != null) {
                        Formulario formuTmp = new Formulario(formu.getNombre(), formu.getSector(), formu.getNivelEscolar(), formu.getLatitud(), formu.getLongitud());
                        if (formuInstancia.findByNombre(formuTmp.getNombre()).isEmpty()) {
                            formuInstancia.crear(formuTmp);
                        }
                    }
                }

            });

            app.ws("/wsMsg", ws -> {

                ws.onConnect(ctx -> {
                    System.out.println("Conexión Iniciada - "+ctx.getSessionId());
                    usuariosConectados.add(ctx.session);
                });

                ws.onMessage(ctx -> {
                    //Puedo leer los header, parametros entre otros.
                    ctx.headerMap();
                    ctx.pathParamMap();
                    ctx.queryParamMap();
                    boolean condicion = true;
                    FormularioJSON tempFormu = jacksonToObject(ctx.message());
                    for(FormularioJSON formu : formulariosRecibidos){
                        if(tempFormu.getId() == formu.getId()){
                            condicion = false;
                        }
                    }
                    if(condicion){
                        formulariosRecibidos.add(tempFormu);
                    }

                    //
                    System.out.println("Mensaje Recibido de "+ctx.getSessionId()+" ====== ");
                    System.out.println("Mensaje: "+ ctx.message());
                    System.out.println("================================");
                    //
                });

                ws.onBinaryMessage(ctx -> {
                    System.out.println("Mensaje Recibido Binario "+ctx.getSessionId()+" ====== ");
                    System.out.println("Mensaje: "+ctx.data().length);
                    System.out.println("================================");
                });

                ws.onClose(ctx -> {
                    System.out.println("Conexión Cerrada - "+ctx.getSessionId());
                    usuariosConectados.remove(ctx.session);
                });

                ws.onError(ctx -> {
                    System.out.println("Ocurrió un error en el WS");
                });
            });
        });
    }

    public static FormularioJSON jacksonToObject(String jsonString)
            throws IOException {
        ObjectMapper mapper = new ObjectMapper();

//        String jsonStr = mapper.writeValueAsString(foo);
//        assertEquals(foo.getId(),result.getId());
        return mapper.readValue(jsonString, FormularioJSON.class);
    }

}
