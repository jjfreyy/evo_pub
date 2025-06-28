<?php 
namespace App\Libraries;

class Validation {
    protected $val;
    protected $label;
    protected $canEmpty = true;
    protected $stop = false;
    protected $isValid = true;
    protected $msg;

    function __construct($val, $label) {
        if (isEmpty($val)) $this->val = "";
        else $this->val = jtrim($val);
        $this->label = $label;
        return $this;
    }

    function getVal() {
        return $this->val;
    }

    function result() {
        if (($this->canEmpty && isEmpty($this->val)) || $this->isValid)
            return ["valid" => true];
        return ["valid" => false, "msg" => $this->msg];
    }

    // private function
        private function _isValid() {
            return (!($this->canEmpty && isEmpty($this->val)) && !$this->stop && $this->isValid);
        }

        private function _setInvalid($msg) {
            $this->isValid = false;
            $this->msg = $msg;
        }
    // private function
    // validation function
        function alphaNumericDash() {
            if ($this->_isValid() && !preg_match("/^[a-z0-9\-]{1,}$/i", $this->val))
                $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfanumerik dan setrip.");
            return $this;
        }

        function alphaNumericDashUnderscore() {
            if ($this->_isValid() && !preg_match("/^[a-z0-9\-\_]{1,}$/i", $this->val)) {
              $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfanumerik, underscore dan setrip.");
            }
            return $this;
        }

        function alphaNumericDashSpaceUnderscore() {
            if ($this->_isValid() && !preg_match("/^[a-z0-9\s\-\_]{1,}$/i", $this->val)) {
              $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfanumerik, spasi, underscore dan setrip.");
            }
            return $this;
        }

        function alphaNumericPunct() {
            if ($this->_isValid() && !preg_match("/^[a-z0-9\s\!\$\%\&\*\-\_\+\=\|\:\.\@\']{1,}$/i", $this->val)) 
                $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfanumerik, spasi dan karakter ! $% & * - _ + = | :.@'.");
            return $this;
        }

        function alphaNumericSpace() {
            if ($this->_isValid() && !preg_match("/^[a-z0-9\s]{1,}$/i", $this->val))
                $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfanumerik dan spasi.");
            return $this;
        }

        function alphaNumericUnderscore() {
            if ($this->_isValid() && !preg_match("/^[a-z0-9\_]{1,}$/i", $this->val)) {
              $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfanumerik dan underscore.");
            }
            return $this;
        }

        function alphaSpace() {
            if ($this->_isValid() && !preg_match("/^[a-z\s\.]{1,}$/i", $this->val))
                $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter alfabet dan spasi.");
            return $this;
        }

        function chineseName() {
            if ($this->_isValid() && !preg_match("/^[\p{L}\s\.\(\)]{1,}$/u", $this->val)) 
                $this->_setInvalid("Bidang $this->label bukan merupakan karakter mandarin yang valid.");
            return $this;
        }

        function decimal($scaleLength = 2) {
            if ($this->_isValid() && !preg_match("/^[-]?[0-9]{1,}(\.[0-9]+)?$/", $this->val)) 
                $this->_setInvalid("Bidang $this->label harus mengandung sebuah angka desimal.");
            return $this;
        }

        function greaterThan($val) {
            if ($this->_isValid() && !($this->val > $val)) 
                $this->_setInvalid("Bidang $this->label harus berisi sebuah angka yang lebih besar dari $val.");
            return $this;
        }

        function greaterThanEqualTo($val) {
            if ($this->_isValid() && !($this->val >= $val)) 
                $this->_setInvalid("Bidang $this->label harus berisi sebuah angka yang lebih besar atau sama dengan $val.");
            return $this;
        }

        function integer() {
            if ($this->_isValid() && !preg_match("/^[\-]?[0-9]{1,}$/", $this->val)) 
                $this->_setInvalid("Bidang $this->label harus mengandung bilangan bulat.");
            return $this;
        }

        function inList($list) {
            if ($this->_isValid() && !in_array($this->val, $list)) 
                $this->_setInvalid("Bidang $this->label harus salah satu dari: " .(implode(", ", $list)). ".");
            return $this;
        }

        function isNotUnique($table, $field, $customFilter = []) {
            if (!$this->_isValid()) return $this;
            $isValid = true;
            try {
                $query = "SELECT 1 FROM $table WHERE $field = '$this->val'";
                if (count($customFilter) > 0) {
                    $query .= " AND ";
                    foreach ($customFilter as $k => $v) {
                        $filters[] = "$k = '$v'";
                    }
                    
                    $query .= implode(" AND ", $filters);
                }

                if (count(dbGet($query)) === 0) $isValid = false; 
            } catch (\Exception $e) {
                $isValid = false;
            }

            if (!$isValid) {
                $this->_setInvalid("Bidang $this->label harus berisi nilai yang sudah ada sebelumnya dalam database.");
            }

            return $this;
        }

        function isUnique($table, $field, $customFilter = []) {
            if (!$this->_isValid()) return $this;
            $isValid = true;
            try {
                $query = "SELECT 1 FROM $table WHERE $field = '$this->val'";
                if (count($customFilter) > 0) {
                    $query .= " AND ";
                    foreach ($customFilter as $k => $v) {
                        $filters[] = "$k = '$v'"; 
                    }
                    $query .= implode(" AND ", $filters);
                }
                
                if (count(dbGet($query)) > 0) $isValid = false;
            } catch (\Exception $e) {
                $isValid = false;
            }

            if (!$isValid) {
                $this->_setInvalid("Bidang $this->label harus mengandung sebuah nilai unik.");
            }

            return $this;
        }

        function lessThan($val) {
            if ($this->_isValid() && !($this->val < $val))
                $this->_setInvalid("Bidang $this->label harus berisi sebuah angka yang kurang dari $val.");
            return $this;
        }

        function lessThanEqualTo($val) {
            if ($this->_isValid() && !($this->val <= $val))
                $this->_setInvalid("Bidang $this->label harus berisi sebuah angka yang kurang dari $val.");
            return $this;
        }

        function letterPrefix() {
            if ($this->_isValid() && !preg_match("/^[a-z]/", $this->val)) 
                $this->_setInvalid("Bidang $this->label harus diawali dengan karakter alfabet.");
            return $this;
        }

        function maxLength($length) {
            if ($this->_isValid() && strlen($this->val) > $length) 
                $this->_setInvalid("Bidang $this->label tidak bisa melebihi $length panjang karakter.");
            return $this;
        }

        function minLength($length) {
            if ($this->_isValid() && strlen($this->val) < $length)
                $this->_setInvalid("Bidang $this->label setidaknya harus $length panjang karakter.");
            return $this;
        }

        function notInList($list) {
            if ($this->_isValid() && in_array($this->val, $list)) 
                $this->_setInvalid("Bidang $this->label tidak boleh salah satu dari: " .(implode(", ", $list)). ".");
            return $this;
        }

        function numericDashSpace() {
            if ($this->_isValid() && !preg_match("/^([0-9]([0-9\-\_\s][0-9])?){1,}$/i", $this->val)) 
                $this->_setInvalid("Bidang $this->label hanya boleh berisi karakter numerik, underscore, tanda setrip dan spasi.");
            return $this;
        }

        function passwordMatch($confirmPassword) {
            if ($this->_isValid() && $this->val !== $confirmPassword) {
              $this->_setInvalid("Password dan konfirmasi password tidak sama.");
            }
            return $this;
        }

        function required() {
            $this->canEmpty = false;
            if (isEmpty($this->val)) $this->_setInvalid("Bidang $this->label diperlukan.");
            return $this;
        }

        function requiredIf($fields) {
            foreach ($fields as $k => $v) {
                if ($v[0] === $v[1] && isEmpty($this->val)) {
                    $this->canEmpty = false;
                    $this->_setInvalid("Bidang $this->label diperlukan saat $k: $v[1]");
                    break;
                }
            }

            return $this;
        }

        function requiredWith($fields) {
            $required = false;
            $labels = [];
            foreach ($fields as $k => $v) {
                if (!isEmpty($v)) {
                    $labels[] = $k;
                    $required = true;
                }
            }
            if ($required && isEmpty($this->val)) {
                $this->canEmpty = false;
                $this->_setInvalid("Bidang $this->label diperlukan saat " . implode(", ", $labels) . " hadir.");
            }
            return $this;
        }

        function requiredWithout($fields) {
            $required = false;
            $labels = [];
            foreach ($fields as $k => $v) {
                if (isEmpty($v)) {
                    $labels[] = $k;
                    $required = true;
                } 
            }
            if ($required && isEmpty($this->val)) {
                $this->_setInvalid("Bidang $this->label diperlukan saat " . implode(", ", $labels) . " tidak hadir.");
            }
            return $this;
        }

        function validDate() {
            if (!$this->_isValid()) goto end;
            
            $dateArr = explode("-", $this->val);
            
            if (count($dateArr) != 3) goto invalid;
            if (!is_numeric($dateArr[0]) || !is_numeric($dateArr[1]) || !is_numeric($dateArr[2])) goto invalid;
            
            $day_index = 2;
            $month_index = 1;
            $year_index = 0;
            if (!checkdate($dateArr[$month_index], $dateArr[$day_index], $dateArr[$year_index])) goto invalid;
            
            goto end;

            invalid:
                $this->_setInvalid("Bidang $this->label harus berisi sebuah tanggal yang valid.");
            
            end:
                return $this;
        }

        function validEmail() {
            if ($this->_isValid() && !filter_var($this->val, FILTER_VALIDATE_EMAIL)) 
                $this->_setInvalid("Bidang $this->label harus berisi sebuah alamat email yang valid.");
            return $this;
        }

        function validPhone() {
            if ($this->_isValid() && !preg_match("/^([\+])?[\d]{3,5}(([\s\-])?[\d]{3,4}){2,}$/", $this->val)) 
                $this->_setInvalid("Bidang $this->label harus berisi nomor telepon yang valid.");
            return $this;
        }

        function validUrl() {
            if ($this->_isValid() && !filter_var($str, FILTER_VALIDATE_URL)) $this->_setInvalid("Bidang $this->label harus berisi sebuah URL yang valid.");
            return $this;
        }
    // validation function
  
  static function set($val, $label) {
      return new Validation($val, $label);
  }

}
