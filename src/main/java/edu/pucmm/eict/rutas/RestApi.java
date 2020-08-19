package edu.pucmm.eict.rutas;

import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.controladora.UsuarioServicios;
import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.FormularioJSON;
import io.javalin.Javalin;
import io.jsonwebtoken.*;

import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;
import java.security.Key;
import java.util.Date;

import static io.javalin.apibuilder.ApiBuilder.*;

public class RestApi {
    public final static String SECRET_KEY = "ghQaYY7Wo24sDqKSX3IM9ASGmdGPmkTd9jo1QTy4b7P9Ze5_9hKolVX8xNrQDcNRfVEdTZNOuOyqEGhXEbdJI-ZQ19k_o9MI0y3eZN2lp9jow55FfXMiINEdt1XR85VipRLSOkT6kSpzs2x-jbLDiz9iFVzkd81YKxMgPA7VfZeQUm4n-mOmnWMaVX30zGFU4L3oPBctYKkl4dYfqYWqRNfrgPJVi5DGFjywgxx0ASEiJHtV72paI3fDR2XwlSkyhhmY-ICjCRmsJN4fX1pdoL8a18-aQrvyu4j0Os6dVPYIoPvvY0SAZtWYKHfM15g7A3HD4cVREf9cUsprCRK93w";
    private Javalin app;
    public RestApi(Javalin app) { this.app = app; }
    FormularioServicios formularios = FormularioServicios.getInstance();

    public void rutas(){
        app.routes(() -> {

            path("/api/formularios", () -> {
                before("/", ctx -> {
                    if(ctx.req.getMethod() == "OPTIONS"){
                        return;
                    }
                    String header = "Authorization";
                    String usuario = ctx.queryParam("usuario");
                    String password = ctx.queryParam("password");

                    if(UsuarioServicios.getInstance().verify_user(usuario, password)){
                        ctx.res.addHeader(header, createJWT(usuario));
                    } else {
                        ctx.res.sendError(403, "No tiene permiso para acceder al recurso");
                    }
                });

                after("/", ctx -> {
                    String headerAuth = ctx.req.getHeader("Authorization");
                    if(headerAuth != null){
                        System.out.println("JWT Recibido" + decodeJWT(headerAuth));
                    }
                    ctx.header("Content-Type", "application/json");
                });

                get("/", ctx -> {
                    ctx.json(formularios.ListadoCompleto());
                });

                post("/", ctx -> {
                    FormularioJSON tmp = ctx.bodyAsClass(FormularioJSON.class);
                    if(tmp.getNombre() != null && tmp.getSector() != null && tmp.getNivelEscolar() != null){
                        Formulario formulario = new Formulario(tmp.getNombre(), tmp.getSector(), tmp.getNivelEscolar(), tmp.getLatitud(), tmp.getLongitud(), tmp.getMimeType(), tmp.getFotoBase64());
                        if(formularios.findByNombre(formulario.getNombre()).isEmpty()){
                            ctx.json(formularios.crear(formulario));
                        } else ctx.json("Formulario ya existe.");
                    } else ctx.json("Transaccion fallida.");
                });
            });
        });
    }

    public static String createJWT(String username) {

        //The JWT signature algorithm we will be using to sign the token
        SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;

        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);

        //We will sign our JWT with our ApiKey secret
        byte[] apiKeySecretBytes = DatatypeConverter.parseBase64Binary(SECRET_KEY);
        Key signingKey = new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());

        //Let's set the JWT Claims
        JwtBuilder builder = Jwts.builder().setId(username)
                .setIssuedAt(now)
                .setSubject("Final Web")
                .setIssuer("PUCMM-EICT")
                .signWith(signatureAlgorithm, signingKey);

        // 5 minutes para expiracion
        long expMillis = nowMillis + 300000;
        Date exp = new Date(expMillis);
        builder.setExpiration(exp);

        //Builds the JWT and serializes it to a compact, URL-safe string
        return builder.compact();
    }

    public static Claims decodeJWT(String jwt) {

        //This line will throw an exception if it is not a signed JWS (as expected)
        Claims claims = Jwts.parser()
                .setSigningKey(DatatypeConverter.parseBase64Binary(SECRET_KEY))
                .parseClaimsJws(jwt).getBody();
        return claims;
    }
}
