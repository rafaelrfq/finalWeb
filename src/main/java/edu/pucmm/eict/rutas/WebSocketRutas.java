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

    FormularioServicios formuInstancia = FormularioServicios.getInstance();

    public void rutas(){
        app.routes(() -> {
            app.ws("/wsMsg", ws -> {

                ws.onConnect(ctx -> {
                    System.out.println("Conexión Iniciada - "+ctx.getSessionId());
                    usuariosConectados.add(ctx.session);
                });

                ws.onMessage(ctx -> {
                    //Puedo leer los header, parametros entre otros.
                    FormularioJSON tempJson = jacksonToObject(ctx.message());
                    Formulario formulario = new Formulario(tempJson.getNombre(), tempJson.getSector(), tempJson.getNivelEscolar(), tempJson.getLatitud(), tempJson.getLongitud(), tempJson.getMimeType(), tempJson.getFotoBase64());
                    formuInstancia.crear(formulario);

                    //
                    System.out.println("Mensaje Recibido de "+ctx.getSessionId()+" ====== ");
//                    System.out.println("Mensaje: "+ ctx.message());
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
                    System.out.println("Ocurrió un error en el WS\n" + ctx.error().toString());
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
