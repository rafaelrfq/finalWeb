package edu.pucmm.eict.rutas;

import edu.pucmm.eict.controladora.UsuarioServicios;
import edu.pucmm.eict.logico.Usuario;
import io.javalin.Javalin;

import java.util.HashMap;
import java.util.Map;

import static j2html.TagCreator.p;

public class LoginRutas {
    private Javalin app;
    public LoginRutas(Javalin app) { this.app = app; }
    UsuarioServicios usuarios = UsuarioServicios.getInstance();

    public void rutas(){
        // Path: localhost:7000/

        app.get("/login", ctx -> {
            ctx.req.getSession().invalidate();
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("error", "");
            ctx.render("/public/templates/login/login.ftl",contexto);


        });

        app.post("/login", ctx -> {
            if (usuarios.verify_user(ctx.formParam("user"), ctx.formParam("password"))){

                ctx.sessionAttribute("usuario", usuarios.getUsuario(ctx.formParam("user")));
                ctx.redirect("/home");
            }else{
                Map<String, Object> contexto = new HashMap<>();
                contexto.put("error", p("Usuario/contraseña inccorecto").withClass("rojo").render());
                ctx.render("/public/templates/login/login.ftl", contexto);
            }

        });

        app.get("/register", ctx -> {
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("error","");
            ctx.render("/public/templates/login/register.ftl", contexto);
        });

        app.post("/register", ctx -> {
            if (usuarios.getUsuario(ctx.formParam("user")) == null){
                Usuario aux = new Usuario(ctx.formParam("user"),ctx.formParam("name"),ctx.formParam("password"));
                usuarios.crear(aux);
                ctx.redirect("/login");
            }else{
                Map<String, Object> contexto = new HashMap<>();
                contexto.put("error", p("Usuario existente").withClass("rojo").render());
                ctx.render("/public/templates/login/register.ftl",contexto);
            }
        });
    }
}
