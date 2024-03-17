<?php

namespace Geekbrains\Application1\Domain\Models;

use Geekbrains\Application1\Application\Application;
use Geekbrains\Application1\Infrastructure\Storage;
class User
{
    private ?string $userName;
    private ?string $userLastName;
    private ?int $userBirthday;
    private ?int $userId;

    public function __construct(int $id=null, string $name = null, string $lastName = null, int $birthday = null)
    {
        $this->userName = $name;
        $this->userBirthday = $birthday;
        $this->userLastName = $lastName;
        $this->userId = $id;
    }

    public function getId (): ?int
    {
        return $this -> userId;
    }

    public function setUserId (int $userId): void
    {
        $this -> userId = $userId;
    }

    /**
     * @return int|null
     */
    public function getUserId (): ?int
    {
        return $this -> userId;
    }



    public function getUserLastName (): ?string
    {
        return $this -> userLastName;
    }

    public function setUserLastName (?string $userLastName): void
    {
        $this -> userLastName = $userLastName;
    }

    public function getUserName (): string
    {
        return $this -> userName;
    }

    public function setUserName (string $userName): void
    {
        $this -> userName = $userName;
    }

    public function getUserBirthday (): ?int
    {
        return $this -> userBirthday;
    }

    public function setUserBirthday (?int $userBirthday): void
    {
        $this -> userBirthday = $userBirthday;
    }

    public function setBirthDayFromString (?string $birthdayString): void
    {
        if ($birthdayString !== null && $birthdayString !== '') {
            $this -> userBirthday = strtotime ($birthdayString);
        }
    }
    public static function getAllUsersFromStorage (?int $limit=null): array
    {
        $sql = "SELECT * FROM users";
        if(isset($limit) && $limit>0){
            $sql .=" WHERE id_user > ". (int)$limit;
        }
        $handler = Application ::$storage -> get () -> prepare ($sql);
        $handler -> execute ();

        $result = $handler -> fetchAll ();
        $users = [];
        foreach ($result as $item) {
            $user = new User($item['id_user'], $item['user_name'], $item['user_lastname'], $item['user_birthday_timestamp']);
            $users[] = $user;
        }
        return $users;
    }
    public static function getUserById ($userId): ?User
    {
        $user = null;

        $sql = "SELECT * FROM users WHERE id_user = :id_user";
        $handler = Application ::$storage -> get () -> prepare ($sql);
        $handler -> execute (['id_user' => $userId]);

        $result = $handler -> fetch ();

        if ($result) {
            $user = new User(intval($result['id_user']), $result['user_name'], $result['user_lastname'], $result['user_birthday_timestamp']);
            $user -> userId = $userId;
        }

        return $user;
    }

    public static function validateRequestData (): bool
    {
        $result = false;

        if (
            isset($_POST['name']) && !empty($_POST['name']) &&
            isset($_POST['lastname']) && !empty($_POST['lastname']) &&
            isset($_POST['birthday']) && !empty($_POST['birthday'])
        ) {
            if (!preg_match ('/[<>]/', $_POST['name']) && !preg_match ('/[<>]/', $_POST['lastname']) && !preg_match ('/[<>]/', $_POST['birthday'])) {

                if (isset($_SESSION['csrf_token']) || $_SESSION['csrf_token'] =
                        $_POST['csrf_token']) {
                    $result = true;
                } else {
                    $result = false;
                }
            }
        }

        return $result;
    }
    public function setParamsFromRequestData (): void
    {
        $this -> userName = htmlspecialchars ($_POST['name']);
        $this -> userLastName = htmlspecialchars ($_POST['lastname']);
        $this -> setBirthDayFromString ($_POST['birthday']);
    }

    public function saveToStorage ()
    {
        $storage = new Storage();
        if ($this -> userId) {
            $sql = "UPDATE users SET user_name = :user_name, user_lastname = :user_lastname, user_birthday_timestamp = :user_birthday WHERE id_user = :id";
        } else {
            $sql = "INSERT INTO users(user_name, user_lastname, user_birthday_timestamp) VALUES (:user_name, :user_lastname, :user_birthday)";
        }

        $handler = $storage -> get () -> prepare ($sql);
        $params = [
            'user_name' => $this -> userName,
            'user_lastname' => $this -> userLastName,
            'user_birthday' => $this -> userBirthday
        ];

        if ($this -> userId) {
            $params['id'] = $this -> userId;
        }

        $handler -> execute ($params);
    }
    public function deleteFromStorage ()
    {
        $storage = new Storage();
        $sql = "DELETE FROM users WHERE id_user = :id_user";
        $handler = $storage -> get () -> prepare ($sql);

        $handler -> execute ([
            'id_user' => $this -> userId
        ]);
    }
    public function getUserRoles(): array{
        $roles = [];

        if(isset($_SESSION['id_user'])){
            $rolesSql = "SELECT * FROM user_roles WHERE id_user = :id";

            $handler = Application::$storage->get()->prepare($rolesSql);
            $handler->execute(['id' => $_SESSION['id_user']]);
            $result = $handler->fetchAll();

            if(!empty($result)){
                foreach($result as $role){
                    $roles[] = $role['role'];
                }
            }
        }
        return $roles;
    }
    public function getUserDataAsArray() : array {
        $userArray = [
            'id' => $this->userId,
            'username' => $this->userName,
            'userlastname' => $this->userLastName,
            'userbirthday' => date('d.m.Y', $this->userBirthday)
        ];

        return $userArray;
    }
    public static function isAdmin(?int $idUser):bool{
        if ($idUser>0){
            $sql="SELECT role FROM user_roles WHERE role='admin' AND id_user = :id_user";
            $handler=Application::$storage->get ()->prepare ($sql);
            $handler->execute ([
                'id_user'=>$idUser
                ]);
            $result=$handler->fetchAll ();

            if (count ($result)>0){
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
}
