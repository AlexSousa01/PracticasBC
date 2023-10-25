//Alexandre Sousa Cajide
//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract FabricaContract {
    uint idDigits=16; //N digitos del producto (2 primeros = tipo producto)
    uint idModulus=10^idDigits; // (10^16) su modulo devuelve ID de 16 digitos

    struct Product {
        string nombre;
        uint id;
    }

    Product[] public productos; //Array publico de structs Product

    function _crearProducto(string memory _nombre, uint _id) private{
        productos.push(Product(_nombre, _id));
        emit NuevoProducto(productos.length -1, _nombre, _id);
    }

    /*Funcion privada que recibe string y confirma ubicacion en memoria y devuelve uint.
    Vera variables del contrato pero no manipulara asi que view*/
    function _generarIdAleatorio(string memory _str) private view returns(uint){
        uint _rand = uint(keccak256(abi.encodePacked(_str)));
        _rand = _rand % idModulus; //Queremos ID de solo 16 digitos
        return _rand;
    }

    function crearProductoAleatorio(string memory _nombre) public{
        uint _randId = _generarIdAleatorio(_nombre);
        _crearProducto(_nombre, _randId);
    }

    //Evento que avise al frontend cuando se cree un producto para mostrarlo en la app
    event NuevoProducto(uint _ArrayProductoId, string _nombre, uint _id);

    //Almacena clave tipo address y valor tipo uint (publico)
    mapping (uint => address) public productoAPropietario; //Asignar producto a propietario
    mapping (address => uint) public propietarioProductos; //Numero productos propietario

    function Propiedad(uint _productoId) public{
        productoAPropietario[_productoId] = msg.sender; //A un producto le asigna un propietario
        //Aumenta en uno el numero de productos que tiene un propietario
        propietarioProductos[msg.sender]++;
    }

    function getProductosPropietario(address _propietario) view external returns (uint[] memory){
        uint _contador = 0;
        uint[] memory resultado = new uint[] (propietarioProductos[_propietario]);
        //Bucle de long = productos propietario
        for (uint i = 0; i < productos.length; i++){
            //Buscar id del producto en el mapping y devuelve el propietario, compararlo
            if (productoAPropietario[productos[i].id]==_propietario) {
                resultado[_contador]=productos[i].id; //Agregar producto al array de productos
                _contador++; //Puntero del array de productos
            }
        }
        return resultado;
    }
}