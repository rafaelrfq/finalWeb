package edu.pucmm.eict;

import edu.pucmm.eict.controladora.DataBaseServices;
import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.controladora.SoapControlador;
import edu.pucmm.eict.controladora.UsuarioServicios;
import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.Usuario;
import edu.pucmm.eict.rutas.FormularioRutas;
import edu.pucmm.eict.rutas.LoginRutas;
import edu.pucmm.eict.rutas.RestApi;
import edu.pucmm.eict.rutas.WebSocketRutas;
import io.javalin.*;
import io.javalin.core.util.RouteOverviewPlugin;
import java.sql.SQLException;
import java.util.*;

public class Main {
    public static void main(String[] args) throws SQLException {

        // Se inicia la base de datos
        DataBaseServices.getInstancia().startDB();

        // Se prueba la conexion con la DB
        DataBaseServices.getInstancia().testConn();

        // Se agregan usuarios de prueba
        Usuario tmp = new Usuario("admin", "Administradora", "admin");
        UsuarioServicios.getInstance().crear(tmp);
        Formulario formulario = new Formulario("John Carlos", "Espaillar", "Grado", 19.439718, -70.543466);
        FormularioServicios.getInstance().crear(formulario);

        Javalin app = Javalin.create(javalinConfig -> {
            javalinConfig.addStaticFiles("/public"); //Agregamos carpeta public como source de archivos estaticos
            javalinConfig.registerPlugin(new RouteOverviewPlugin("rutas")); //Aplicamos el plugin de rutas
            javalinConfig.wsFactoryConfig(ws -> { ws.getPolicy().setMaxTextMessageSize(5000000); });
        });

        // Manejadores de rutas
        new SoapControlador(app).aplicarRutas();
        app.start(7000);

        new WebSocketRutas(app).rutas();
        new FormularioRutas(app).rutas();
        new LoginRutas(app).rutas();
        new RestApi(app).rutas();

        app.before("/home",ctx ->{
            if(ctx.sessionAttribute("usuario") ==null) {
                ctx.redirect("/login");
            }
        });

        app.get("/", ctx -> {
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Homepage");
            ctx.redirect("/login");
        });

        app.get("/home", ctx -> {
            Usuario aux = ctx.sessionAttribute("usuario");
            System.out.println("Llego: "+aux.getNombre());
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Homepage");
            contexto.put("usuario", aux);
            ctx.render("/public/templates/home.ftl", contexto);
        });


    }
}
