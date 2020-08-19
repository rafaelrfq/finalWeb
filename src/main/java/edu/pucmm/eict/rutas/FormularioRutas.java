package edu.pucmm.eict.rutas;

import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.logico.Formulario;
import io.javalin.Javalin;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.javalin.apibuilder.ApiBuilder.*;
import static io.javalin.apibuilder.ApiBuilder.get;

public class FormularioRutas {
    private Javalin app;
    public FormularioRutas(Javalin app) { this.app = app; }

    public void rutas(){
        app.routes(() -> {

            path("/formulario", () ->{
                before(ctx ->{
                    if(ctx.sessionAttribute("usuario") == null) {
                        ctx.redirect("/login");
                    }
                });

                // Path: localhost:7000/formulario/
                get("/", ctx -> {
                    List<String> choices = Arrays.asList("", "Basico", "Medio", "Grado Universitario", "Postgrado", "Doctorado");
                    Map<String, Object> contexto = new HashMap<>();
                    contexto.put("title", "Formulario");
                    contexto.put("choices", choices);
                    ctx.render("/public/templates/formulario.ftl", contexto);
                });

                // Path: localhost:7000/formulario/listado/
                get("/listado", ctx -> {
                    List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
                    Map<String, Object> contexto = new HashMap<>();
                    contexto.put("title", "Listado Formularios");
                    contexto.put("formularios", forms);
                    ctx.render("/public/templates/listado_formulario.ftl", contexto);
                });

                // Path: localhost:7000/formulario/listado/ver/:id
                get("/listado/ver/:id", ctx -> {
                    Formulario formulario = FormularioServicios.getInstance().find(ctx.pathParam("id", Integer.class).get());
                    Map<String, Object> contexto = new HashMap<>();
                    contexto.put("title", "Ver Formulario");
                    contexto.put("formulario", formulario);
                    ctx.render("/public/templates/ver_formulario.ftl", contexto);
                });

                // Path: localhost:7000/formulario/listado/eliminar/:id
                get("/listado/eliminar/:id", ctx -> {
                    Formulario temporal = FormularioServicios.getInstance().find(ctx.pathParam("id", Integer.class).get());
                    FormularioServicios.getInstance().eliminar(temporal.getId());
                    ctx.redirect("/formulario/listado/");
                });

                // Path: localhost:7000/formulario/mapa/
                get("/mapa", ctx -> {
                    List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
                    Map<String, Object> contexto = new HashMap<>();
                    contexto.put("title", "Listado Formularios Registrado Por el Usuario");
                    contexto.put("formularios", forms);
                    ctx.render("/public/templates/mapa.ftl", contexto);
                });
            });
        });
    }
}
