!classDefinition: #PermisoDenegadoNoSePuede category: #Proyecto!
Error subclass: #PermisoDenegadoNoSePuede
	instanceVariableNames: 'usuarioError tipoDeError'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!PermisoDenegadoNoSePuede methodsFor: 'exceptionBuilder' stamp: 'JGG 6/21/2018 09:22:38'!
errorHandle: unUsuario
	"Especifica el tipo de error que ha cometido el usuario."
	tipoDeError _ unUsuario.! !


!PermisoDenegadoNoSePuede methodsFor: 'exceptionDescription' stamp: 'JGG 6/21/2018 09:22:45'!
errorHandle
	^ tipoDeError .! !

!PermisoDenegadoNoSePuede methodsFor: 'exceptionDescription' stamp: 'JGG 6/21/2018 16:20:53'!
messageText
	
	^tipoDeError! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PermisoDenegadoNoSePuede class' category: #Proyecto!
PermisoDenegadoNoSePuede class
	instanceVariableNames: ''!

!PermisoDenegadoNoSePuede class methodsFor: 'signaling' stamp: 'JGG 6/21/2018 16:15:31'!
señalConError: unMensajeDeError

	^(self errorHandle: unMensajeDeError )! !


!PermisoDenegadoNoSePuede class methodsFor: 'exceptionInstantiator' stamp: 'JGG 6/21/2018 15:57:02'!
errorHandle: unMensajeDeError
	
	^self new errorHandle: unMensajeDeError.! !


!classDefinition: #TPMiniUnixTest category: #Proyecto!
TestCase subclass: #TPMiniUnixTest
	instanceVariableNames: 'unix'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'DE 6/19/2018 21:34:37'!
setUp

	unix := SistemaOperativoUnix new.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'DE 6/16/2018 22:20:22'!
test02ElUsuarioRootIniciaSesionCorrectamente
	
	unix iniciarSesion: 'root' conContraseña: '000000'.
	
	Assert that: unix usuarioActual nombre isEqualTo: 'root'! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 16:31:51'!
test03ElUsuarioRootNoIniciaSesionPorUsarUnaContraseñaIncorrecta

	Assert should: [unix iniciarSesion: 'root' conContraseña: '12345' ] signal: PermisoDenegadoNoSePuede withDescription: 'iniciar sesion de root contraseña incorrecta'.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 16:34:10'!
test04ElUsuarioNahuelNoIniciaSesionPorUsuarioIncorrecto

	Assert should: [unix iniciarSesion: 'nahuel' conContraseña: 'w234' ] signal: PermisoDenegadoNoSePuede withDescription: 'iniciar sesion nahuel no existe'.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'DE 6/19/2018 21:38:24'!
test05ElUsuarioRootCreaAlUsuarioNahuel
	
	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix registrarUsuario: 'Nahuel' conContraseña: 'H3lpM3'.
	
	Assert isTrue:(unix incluyeUsuario:'Nahuel')! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 16:37:43'!
test06ElUsuarioRootIntentaCrearAlUsuarioNahuel2Veces

	unix
		iniciarSesion: 'root'
		conContraseña: '000000'.
	unix
		registrarUsuario: 'Nahuel'
		conContraseña: 'H3lpM3'.
		
	Assert should: [unix registrarUsuario: 'Nahuel' conContraseña: 'H3lpM4' ] signal: PermisoDenegadoNoSePuede withDescription: 'registrar usuario Nahuel ya existe'.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 16:35:55'!
test07ElUsuarioRootCreaAlUsuarioNahuelQuienTrataDeCrearAlUsuarioFranYNoPuede

	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix registrarUsuario: 'Nahuel' conContraseña: 'H3lpM3'.
	unix iniciarSesion: 'Nahuel' conContraseña: 'H3lpM3'.

	Assert should: [unix registrarUsuario: 'Fran' conContraseña: '413' ] signal: PermisoDenegadoNoSePuede withDescription: 'registrar usuario Fran'.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'DE 6/19/2018 21:41:05'!
test08ElUsuarioRootCreaAlUsuarioNahuelYLuegoLoElimina

	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix registrarUsuario: 'Nahuel' conContraseña: 'H3lpM3'.
	unix eliminarUsuario: 'Nahuel'.
	
	Assert isFalse: (unix incluyeUsuario: 'Nahuel').! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 16:19:28'!
test09ElUsuarioRootCreaAlUsuarioNahuelYAlUsuarioFranYLuegoNahuelTrataDeEliminarAFranYNoPuede

	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix registrarUsuario: 'Nahuel' conContraseña: 'H3lpM3'.
	unix registrarUsuario: 'Fran' conContraseña: '413'.
	unix iniciarSesion: 'Nahuel' conContraseña: 'H3lpM3'.
	
	Assert should: [unix eliminarUsuario: 'Fran'] signal: PermisoDenegadoNoSePuede withDescription: 'eliminar usuario Fran'! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'DE 6/24/2018 10:34:27'!
test10ElUsuarioRootTrataDeEliminarSuUsuarioYNoPuede

	unix iniciarSesion: 'root' conContraseña: '000000'.
	
	Assert should: [ unix eliminarUsuario: 'root' ] signal: PermisoDenegadoNoSePuede withDescription: 'eliminar usuario root'.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 13:00:23'!
test11ElUsuarioRootCreaUnaNuevaCarpetaLlamada1
	
	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix crearLaCarpeta: '1'.
		
	Assert isTrue: (unix incluyeElDirectorio: '1')! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 13:21:21'!
test12ElUsuarioRootCreaUnaCarpetaYLuegoTrataDeEliminarlaYPuede

	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix crearLaCarpeta: 'carpeta'.
	unix eliminarCarpeta: 'carpeta'.
	
	Assert isFalse: (unix incluyeElDirectorio: 'carpeta')! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 17:52:18'!
test13ElUsuarioRootCreaUnaCarpetaYLuegoelUsuarioNahuelTrataDeEliminarlaYNoPuede

	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix crearLaCarpeta: 'carpeta'.
	unix registrarUsuario: 'Nahuel' conContraseña: '12340'.
	unix iniciarSesion: 'Nahuel' conContraseña: '12340'.
	
	Assert should: [	unix eliminarCarpeta: 'carpeta'] signal: PermisoDenegadoNoSePuede withDescription: 'eliminar la carpeta: carpeta'.! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 17:54:33'!
test14ElUsuarioRootCreaUnaCarpetaLlamadaMisDocumentosYSeMueveAEsta
	
	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix crearLaCarpeta: 'MisDocumentos'.
	unix moverASubdirectorio: 'MisDocumentos'.
	
	Assert that: unix carpetaActual isEqualTo: 'MisDocumentos'! !

!TPMiniUnixTest methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 17:54:14'!
test15ElUsuarioRootCreaUnaCarpetaLlamadaMisDocumentosYSeMueveAEstaYVuelveARaiz
	
	unix iniciarSesion: 'root' conContraseña: '000000'.
	unix crearLaCarpeta: 'MisDocumentos'.
	unix moverASubdirectorio: 'MisDocumentos'.
	unix moverASupradirectorio.
	
	Assert that: unix carpetaActual isEqualTo: 'raiz'! !


!classDefinition: #AdministradorDePermisos category: #Proyecto!
Object subclass: #AdministradorDePermisos
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!AdministradorDePermisos methodsFor: 'as yet unclassified' stamp: 'DE 6/19/2018 20:50:58'!
registra: unUsuario con: unaContraseña para: unSistemaOperativo

	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AdministradorDePermisos class' category: #Proyecto!
AdministradorDePermisos class
	instanceVariableNames: ''!


!AdministradorDePermisos class methodsFor: 'evaluating' stamp: 'DE 6/19/2018 20:50:50'!
canHandle: unUsuario en: unSistemaOperativoUnix 

	self subclassResponsibility.! !


!AdministradorDePermisos class methodsFor: 'subclass creation' stamp: 'DE 6/24/2018 10:34:13'!
eliminacion
	^ {PermisoDenegado. PermisoConcedido}.! !

!AdministradorDePermisos class methodsFor: 'subclass creation' stamp: 'JGG 6/21/2018 15:03:26'!
eliminarUsuario: unUsuario en: unSistemaOperativoUnix

	^ (self eliminacion detect: [ :subclass | subclass puedeEliminarUsuario: unUsuario en: unSistemaOperativoUnix ]) new.! !


!AdministradorDePermisos class methodsFor: 'Sesion(crear)' stamp: 'JGG 6/21/2018 15:45:42'!
IniciarSesionDe: unUsuario con: unaContraseña para: unSistemaOperativoUnix 
	
	^ (self sesiones detect:[:subclass|subclass puedeIniciarSesion: unUsuario con: unaContraseña en: unSistemaOperativoUnix]) new.! !

!AdministradorDePermisos class methodsFor: 'Sesion(crear)' stamp: 'JGG 6/21/2018 15:13:27'!
registra: unUsuario con: unaContraseña para: unSistemaOperativoUnix 
	
	^ (self registros detect:[:subclass|subclass puedeCrearUsuario: unUsuario en: unSistemaOperativoUnix]) new.! !

!AdministradorDePermisos class methodsFor: 'Sesion(crear)' stamp: 'JGG 6/21/2018 17:50:52'!
registros
	^ {PermisoConcedido. PermisoDenegado. ElUsuarioYaExiste}.! !

!AdministradorDePermisos class methodsFor: 'Sesion(crear)' stamp: 'JGG 6/21/2018 17:50:52'!
sesiones
	^ {PermisoConcedido. ContraseñaIncorrecta. UsuarioNoExiste}.! !


!AdministradorDePermisos class methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 17:50:52'!
eliminaCarpeta
	^ {PermisoConcedido. PermisoDenegado}.! !

!AdministradorDePermisos class methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 17:19:58'!
eliminarCarpetaClase: unaCarpeta en: unSistemaOperativoUnix

	^ (self eliminaCarpeta detect: [ :subclass | subclass puedeEliminarCarpeta: unaCarpeta en: unSistemaOperativoUnix ]) new.! !


!classDefinition: #ContraseñaIncorrecta category: #Proyecto!
AdministradorDePermisos subclass: #ContraseñaIncorrecta
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!ContraseñaIncorrecta methodsFor: 'message handling' stamp: 'JGG 6/21/2018 16:30:48'!
iniciarSesionDe: unUsuario en: unSistemaOperativoUnix conContraseña: aString3
	"Error 'contraseña incorrecta'"
	^(PermisoDenegadoNoSePuede errorHandle: 'iniciar sesion de ' , unUsuario, ' contraseña incorrecta')signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ContraseñaIncorrecta class' category: #Proyecto!
ContraseñaIncorrecta class
	instanceVariableNames: ''!

!ContraseñaIncorrecta class methodsFor: 'evaluating' stamp: 'DE 6/19/2018 20:52:23'!
canHandle: unUsuario con: unaContraseña en: unSistemaOperativo
	
	^ unSistemaOperativo usuarios anySatisfy: [:usuario| (usuario nombre = unUsuario) & ((usuario contraseña = unaContraseña )not)].! !


!ContraseñaIncorrecta class methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 15:46:40'!
puedeIniciarSesion:  unUsuario con: unaContraseña en: unSistemaOperativo
	
	^ unSistemaOperativo usuarios anySatisfy: [:usuario| (usuario nombre = unUsuario) & ((usuario contraseña = unaContraseña )not)].! !


!classDefinition: #ElUsuarioYaExiste category: #Proyecto!
AdministradorDePermisos subclass: #ElUsuarioYaExiste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!ElUsuarioYaExiste methodsFor: 'message handling' stamp: 'JGG 6/21/2018 16:37:31'!
registrar: unUsuario con: unaContraseña para: unSistemaOperativo
	"Error El Usuario (unUsuario nombre) ya existe"
	^ (PermisoDenegadoNoSePuede errorHandle: 'registrar usuario ' , unUsuario, ' ya existe')signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElUsuarioYaExiste class' category: #Proyecto!
ElUsuarioYaExiste class
	instanceVariableNames: ''!

!ElUsuarioYaExiste class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 15:20:06'!
puedeCrearUsuario: unUsuario en: unSistemaOperativoUnix 
	
	^ (unSistemaOperativoUnix usuarios anySatisfy: [:usuario | usuario nombre = unUsuario ])! !


!classDefinition: #PermisoDenegado category: #Proyecto!
AdministradorDePermisos subclass: #PermisoDenegado
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!PermisoDenegado methodsFor: 'message handling' stamp: 'JGG 6/21/2018 17:51:47'!
eliminarCarpeta: unaCarpeta en: unSistemaOperativoUnix

	^ (PermisoDenegadoNoSePuede errorHandle: 'eliminar la carpeta: ' , unaCarpeta)signal! !

!PermisoDenegado methodsFor: 'message handling' stamp: 'JGG 6/21/2018 17:49:06'!
eliminarUsuario: aString en: aSistemaOperativoUnix
	"el Usuario unix usuarioActual carece de los permisos necesarios"
	^ (PermisoDenegadoNoSePuede errorHandle: 'eliminar usuario ' , aString)signal! !

!PermisoDenegado methodsFor: 'message handling' stamp: 'JGG 6/21/2018 17:49:06'!
registrar: unUsuario con: unaContraseña para: unSistemaOperativoUnix
	"Error usuario (unUsuario) no tiene los permisos para realizar esta accion"
	^ (PermisoDenegadoNoSePuede errorHandle: 'registrar usuario ' , unUsuario)signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PermisoDenegado class' category: #Proyecto!
PermisoDenegado class
	instanceVariableNames: ''!

!PermisoDenegado class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 17:49:06'!
puedeCrearUsuario: unUsuario en: unSistemaOperativoUnix

	^ (unSistemaOperativoUnix usuarioActual nombre = 'root') not.! !

!PermisoDenegado class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 17:49:07'!
puedeEliminarCarpeta: unaCarpeta en: unSistemaOperativo

	|usuarioActual|
	usuarioActual := unSistemaOperativo usuarioActual.

	^((usuarioActual = 'root') or: ((unSistemaOperativo dueñoDeCarpeta: unaCarpeta) = usuarioActual)) not.! !

!PermisoDenegado class methodsFor: 'evaluating' stamp: 'DE 6/24/2018 10:55:14'!
puedeEliminarUsuario: unUsuario en: unSistemaOperativo
	
	^ (unSistemaOperativo usuarioActual nombre = 'root')not or: (unUsuario = 'root') or: (unSistemaOperativo usuarios noneSatisfy: [:usuario|usuario nombre =unUsuario]).! !


!classDefinition: #Carpeta category: #Proyecto!
Object subclass: #Carpeta
	instanceVariableNames: 'nombre creador ubicacion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!Carpeta methodsFor: 'converting' stamp: 'DE 6/20/2018 19:43:05'!
conNombre: unNombre creadaPor: unUsuario 
	
	nombre _ unNombre.
	creador _ unUsuario ! !

!Carpeta methodsFor: 'converting' stamp: 'JGG 6/21/2018 13:23:02'!
conNombre: unNombre creadaPor: unUsuario en: unDirectorio
	
	nombre _ unNombre.
	creador _ unUsuario.
	ubicacion _ unDirectorio! !


!Carpeta methodsFor: 'accessing' stamp: 'JGG 6/21/2018 14:49:09'!
creador
	
	^creador! !

!Carpeta methodsFor: 'accessing' stamp: 'DE 6/20/2018 19:44:37'!
nombre
	
	^nombre! !

!Carpeta methodsFor: 'accessing' stamp: 'JGG 6/21/2018 14:49:25'!
ubicacion
	
	^ubicacion! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Carpeta class' category: #Proyecto!
Carpeta class
	instanceVariableNames: ''!

!Carpeta class methodsFor: 'class initialization' stamp: 'DE 6/20/2018 19:41:39'!
conNombre: unNombre creadaPor: unUsuario 
	
	^ self new conNombre: unNombre creadaPor: unUsuario.! !


!Carpeta class methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 14:15:35'!
conNombre: unNombre creadaPor: unUsuario en: unDirectorio 
	
	^ self new conNombre: unNombre creadaPor: unUsuario en: unDirectorio.! !


!classDefinition: #Firewall category: #Proyecto!
Object subclass: #Firewall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!Firewall methodsFor: 'as yet unclassified' stamp: 'DE 6/16/2018 22:31:18'!
iniciarSesionDe: unUsuario en: unSistemaOperativa conContraseña: unaContraseña 
	
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Firewall class' category: #Proyecto!
Firewall class
	instanceVariableNames: ''!

!Firewall class methodsFor: 'accessing class hierarchy' stamp: 'DE 6/19/2018 20:52:56'!
canHandle: unUsuario con: unaContraseña en: unSistemaOperativo

	^self subclassResponsibility.! !


!classDefinition: #UsuarioNoExiste category: #Proyecto!
Firewall subclass: #UsuarioNoExiste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!UsuarioNoExiste methodsFor: 'message handling' stamp: 'JGG 6/21/2018 16:36:47'!
iniciarSesionDe: unUsuario en: aSistemaOperativoUnix conContraseña: aString3
	"Error usuario incorrecto"
	^ (PermisoDenegadoNoSePuede errorHandle: 'iniciar sesion ' , unUsuario , ' no existe')signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UsuarioNoExiste class' category: #Proyecto!
UsuarioNoExiste class
	instanceVariableNames: ''!

!UsuarioNoExiste class methodsFor: 'as yet unclassified' stamp: 'DE 6/19/2018 20:52:11'!
canHandle: unUsuario con: unaContraseña en: unSistemaOperativo

	^ unSistemaOperativo usuarios noneSatisfy: [:usuario|usuario nombre =unUsuario].! !

!UsuarioNoExiste class methodsFor: 'as yet unclassified' stamp: 'DE 6/20/2018 18:18:50'!
puedeEliminar: unUsuario en: unSistemaOperativo 
	
	^ (unSistemaOperativo incluyeUsuario: unUsuario)not .! !

!UsuarioNoExiste class methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 15:47:43'!
puedeIniciarSesion: unUsuario con: unaContraseña en: unSistemaOperativo

	^ unSistemaOperativo usuarios noneSatisfy: [:usuario|usuario nombre =unUsuario].! !


!classDefinition: #PermisoConcedido category: #Proyecto!
Object subclass: #PermisoConcedido
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!PermisoConcedido methodsFor: 'converting' stamp: 'JGG 6/21/2018 17:21:17'!
eliminarCarpeta: unaCarpeta en: aSistemaOperativoUnix 
	
	aSistemaOperativoUnix eliminarCarpetaExitosa: unaCarpeta.! !

!PermisoConcedido methodsFor: 'converting' stamp: 'DE 6/20/2018 17:14:36'!
eliminarUsuario: unUsuario en: aSistemaOperativoUnix 
	
	aSistemaOperativoUnix eliminacionDeUsuarioAutorizada: unUsuario ! !

!PermisoConcedido methodsFor: 'converting' stamp: 'JGG 6/21/2018 15:31:36'!
iniciarSesionDe: unUsuario en: unSistemaOperativa conContraseña: unaContraseña 
	
	unSistemaOperativa iniciarSesion: unUsuario.! !

!PermisoConcedido methodsFor: 'converting' stamp: 'JGG 6/21/2018 15:30:42'!
registrar: unUsuario con: unaContraseña para: unSistemaOperativoUnix 
	
	unSistemaOperativoUnix registrarA: unUsuario con: unaContraseña! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PermisoConcedido class' category: #Proyecto!
PermisoConcedido class
	instanceVariableNames: ''!

!PermisoConcedido class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 15:30:18'!
puedeCrearUsuario: unUsuario en: unSistemaOperativoUnix 
	
	^ unSistemaOperativoUnix usuarios noneSatisfy: [:usuario | usuario nombre = unUsuario or: ((unSistemaOperativoUnix usuarioActual nombre = 'root')not)]! !

!PermisoConcedido class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 17:15:45'!
puedeEliminarCarpeta: unaCarpeta en: unSistemaOperativo

	|usuarioActual|
	
	usuarioActual  := unSistemaOperativo usuarioActual.

	^(usuarioActual = 'root') or: ((unSistemaOperativo dueñoDeCarpeta: unaCarpeta) = usuarioActual).! !

!PermisoConcedido class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 14:52:13'!
puedeEliminarUsuario: unUsuario en: unSistemaOperativo

	^ unSistemaOperativo usuarioActual nombre = 'root' and: (unUsuario = 'root') not and: (unSistemaOperativo incluyeUsuario: unUsuario).! !

!PermisoConcedido class methodsFor: 'evaluating' stamp: 'JGG 6/21/2018 15:32:29'!
puedeIniciarSesion: unUsuario con: unaContraseña en: unSistemaOperativo
	
	^ unSistemaOperativo usuarios anySatisfy: [:usuario|(usuario nombre = unUsuario)&(usuario contraseña = unaContraseña)].! !


!classDefinition: #SistemaOperativoUnix category: #Proyecto!
Object subclass: #SistemaOperativoUnix
	instanceVariableNames: 'usuarios usuarioActual directorio carpetaActual'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!SistemaOperativoUnix methodsFor: 'Acciones' stamp: 'JGG 6/21/2018 13:25:50'!
crearLaCarpeta: unNombre 
	
	directorio add: (Carpeta conNombre: unNombre creadaPor: usuarioActual en: carpetaActual)! !

!SistemaOperativoUnix methodsFor: 'Acciones' stamp: 'JGG 6/21/2018 17:20:26'!
eliminarCarpeta: unaCarpeta 
	
	(AdministradorDePermisos eliminarCarpetaClase:unaCarpeta en: self)eliminarCarpeta:unaCarpeta en: self
	
	"directorio remove: (directorio detect:[:directorio|directorio nombre = unaCarpeta])"! !

!SistemaOperativoUnix methodsFor: 'Acciones' stamp: 'DE 6/20/2018 19:01:41'!
eliminarUsuario: unUsuario 
	
	(AdministradorDePermisos eliminarUsuario:unUsuario en: self) eliminarUsuario:unUsuario en: self
	"EliminacionNegadaRoot new eliminarUsuario:unUsuario en: self"
	"EliminacionExitosa new eliminarUsuario:unUsuario en: self"
	"PermisosIncorrectos new eliminarUsuario:unUsuario en: self"
	"self usuarios remove: (self usuarios detect:[:usuario| usuario nombre = unUsuario])"
	" (self usuarios detect:[:usuario| usuario nombre = unUsuario])"! !

!SistemaOperativoUnix methodsFor: 'Acciones' stamp: 'JGG 6/21/2018 15:44:44'!
iniciarSesion: unUsuario conContraseña: unaContraseña 
	
	(AdministradorDePermisos IniciarSesionDe: unUsuario con: unaContraseña para: self) iniciarSesionDe: unUsuario en: self conContraseña: unaContraseña
	
	"UsuarioIncorrecto new iniciarSesionDe: unUsuario en: self conContraseña: unaContraseña
	AccesoConcedido new iniciarSesionDe: unUsuario en: self conContraseña: unaContraseña
	ContraseñaIncorrecta new iniciarSesionDe: unUsuario en: self conContraseña: unaContraseña
	usuarioActual _ unUsuario"! !

!SistemaOperativoUnix methodsFor: 'Acciones' stamp: 'JGG 6/21/2018 15:16:51'!
registrarUsuario: unUsuario conContraseña: unaContraseña

	(AdministradorDePermisos registra: unUsuario con: unaContraseña para: self ) registrar: unUsuario con: unaContraseña para: self.
	"RegistroExitoso registra: unUsuario con: unaContraseña para:self "
	"self usuarios add:(Usuario conNombre: unNombre conContraseña: unaContraseña)."! !


!SistemaOperativoUnix methodsFor: 'Acciones-Private' stamp: 'DE 6/20/2018 17:15:24'!
eliminacionDeUsuarioAutorizada: unUsuario 

	usuarios remove: (usuarios detect:[:usuario| usuario nombre = unUsuario])! !

!SistemaOperativoUnix methodsFor: 'Acciones-Private' stamp: 'JGG 6/21/2018 17:23:03'!
eliminarCarpetaExitosa: unaCarpeta 
	
	directorio remove: (directorio detect:[:directorio| directorio nombre = unaCarpeta])! !

!SistemaOperativoUnix methodsFor: 'Acciones-Private' stamp: 'DE 6/16/2018 20:26:04'!
iniciarSesion: unUsuario 
	
	usuarioActual _ (self usuarios detect: [:usuario| usuario nombre = unUsuario])
	
	! !

!SistemaOperativoUnix methodsFor: 'Acciones-Private' stamp: 'DE 6/16/2018 23:16:42'!
registrarA: unNombre con: unaContraseña 
	
	self usuarios add:(Usuario conNombre: unNombre conContraseña: unaContraseña).! !


!SistemaOperativoUnix methodsFor: 'accessing' stamp: 'JGG 6/21/2018 17:30:52'!
carpetaActual

	^carpetaActual.! !

!SistemaOperativoUnix methodsFor: 'accessing' stamp: 'DE 6/20/2018 19:38:29'!
directorio
	
	^directorio! !

!SistemaOperativoUnix methodsFor: 'accessing' stamp: 'DE 6/24/2018 10:49:44'!
dueñoDeCarpeta: unaCarpeta

	^(self carpeta: unaCarpeta) creador.! !

!SistemaOperativoUnix methodsFor: 'accessing' stamp: 'DE 6/24/2018 10:50:12'!
ubicacionDe: unaCarpeta 
	
	^(self carpeta: unaCarpeta) ubicacion! !

!SistemaOperativoUnix methodsFor: 'accessing' stamp: 'DE 6/16/2018 22:19:59'!
usuarioActual
	
	^usuarioActual! !

!SistemaOperativoUnix methodsFor: 'accessing' stamp: 'DE 6/16/2018 20:17:25'!
usuarios
	
	^usuarios! !


!SistemaOperativoUnix methodsFor: 'as yet unclassified' stamp: 'DE 6/24/2018 10:49:56'!
carpeta: unaCarpeta
	
	^directorio detect:[:carpeta|carpeta nombre = unaCarpeta]! !

!SistemaOperativoUnix methodsFor: 'as yet unclassified' stamp: 'JGG 6/21/2018 17:37:12'!
moverASubdirectorio: unaCarpeta 
	
	carpetaActual _ unaCarpeta! !

!SistemaOperativoUnix methodsFor: 'as yet unclassified' stamp: 'DE 6/24/2018 10:36:31'!
moverASupradirectorio

	carpetaActual _  self ubicacionDe: carpetaActual! !


!SistemaOperativoUnix methodsFor: 'evaluating' stamp: 'DE 6/24/2018 10:46:34'!
incluyeElDirectorio: unDirectorio

	^directorio anySatisfy: [:directorio| directorio nombre = unDirectorio].! !

!SistemaOperativoUnix methodsFor: 'evaluating' stamp: 'DE 6/16/2018 22:41:02'!
incluyeUsuario: unUsuario 
	
	^self usuarios anySatisfy: [:usuario | usuario nombre = unUsuario]! !


!SistemaOperativoUnix methodsFor: 'initialization' stamp: 'JGG 6/21/2018 13:25:24'!
initialize
	
	usuarios _ Set with: (Usuario conNombre: 'root' conContraseña: '000000').
	directorio _ Set with:(Carpeta conNombre: 'raiz' creadaPor: 'root').
	carpetaActual _ 'raiz'! !


!classDefinition: #Usuario category: #Proyecto!
Object subclass: #Usuario
	instanceVariableNames: 'contraseña nombre'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Proyecto'!

!Usuario methodsFor: 'accessing' stamp: 'DE 6/16/2018 17:22:25'!
contraseña
	
	^contraseña! !

!Usuario methodsFor: 'accessing' stamp: 'DE 6/16/2018 17:25:22'!
nombre
	
	^nombre! !


!Usuario methodsFor: 'converting' stamp: 'DE 6/16/2018 17:21:42'!
nuevaContraseña: unaContraseña 
	
	contraseña := unaContraseña.! !

!Usuario methodsFor: 'converting' stamp: 'DE 6/16/2018 17:22:14'!
nuevoNombre: unNombre
	
	nombre := unNombre! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Usuario class' category: #Proyecto!
Usuario class
	instanceVariableNames: ''!

!Usuario class methodsFor: 'class initialization' stamp: 'DE 6/16/2018 17:24:54'!
conNombre: unNombre conContraseña:  unaContraseña

	^self new nuevoNombre: unNombre; nuevaContraseña: unaContraseña.! !
