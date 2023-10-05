// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Kontrak pintar Perpustakaan
contract Perpustakaan {
    struct Buku {
        string ISBN;
        string judul;
        uint256 tahunDibuat;
        string penulis;
    }

    // Array untuk menyimpan buku-buku
    Buku[] public buku;

    // Mapping untuk memeriksa apakah alamat adalah admin
    mapping(address => bool) public isAdmin;

    // Modifikasi admin untuk membatasi akses
    modifier hanyaAdmin() {
        require(isAdmin[msg.sender], "Hanya admin yang bisa mengakses fungsi ini");
        _;
    }

    // Konstruktor untuk menginisialisasi admin awal
    constructor() {
        isAdmin[msg.sender] = true;
    }

    // Fungsi untuk menambahkan buku baru
    function tambahBuku(string memory _ISBN, string memory _judul, uint256 _tahun, string memory _penulis) public hanyaAdmin {
        Buku memory newBook = Buku(_ISBN, _judul, _tahun, _penulis);
        buku.push(newBook);
    }

    // Fungsi untuk memperbarui buku berdasarkan ISBN
    function updateBuku(string memory _ISBN, string memory _judul, uint256 _tahun, string memory _penulis) public hanyaAdmin {
        for (uint i = 0; i < buku.length; i++) {
            if (keccak256(bytes(buku[i].ISBN)) == keccak256(bytes(_ISBN))) {
                buku[i].judul = _judul;
                buku[i].tahunDibuat = _tahun;
                buku[i].penulis = _penulis;
                break;
            }
        }
    }

    struct UserDetail {
        address user;
        bool isPassed;
        string userName;
    }
    UserDetail public userDetail;

    mapping(address => uint256) public balance;

    event UserAdded(address user);

    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    modifier onlyOwner {
        require(msg.sender == owner); 
        _;
    }

    // Fungsi untuk menghapus buku berdasarkan ISBN
    function hapusBuku(string memory _ISBN) public hanyaAdmin {
        for (uint i = 0; i < buku.length; i++) {
            if (keccak256(bytes(buku[i].ISBN)) == keccak256(bytes(_ISBN))) {
                delete buku[i];
                break;
            }
        }
    }

    // Fungsi untuk mendapatkan data buku berdasarkan ISBN
    function getDataBuku(string memory _ISBN) public view returns (string memory, string memory, uint256, string memory) {
        for (uint i = 0; i < buku.length; i++) {
            if (keccak256(bytes(buku[i].ISBN)) == keccak256(bytes(_ISBN))) {
                return (buku[i].ISBN, buku[i].judul, buku[i].tahunDibuat, buku[i].penulis);
            }
        }
        revert("Buku dengan ISBN tersebut tidak ditemukan");
    }
}
