function fn() {
  // Cada escenario conserva solamente los IDs que él mismo creó.
  karate.configure('afterScenario', function () {
    var ids = karate.get('idsLimpieza', []);
    for (var i = 0; i < ids.length; i++) {
      karate.call('classpath:helpers/eliminar-usuario.feature', { idUsuario: ids[i] });
    }
  });
  return { baseUrl: 'https://serverest.dev', idsLimpieza: [] };
}
