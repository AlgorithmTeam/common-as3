package common.mathematics
{
    /**
     * 检测整数是否为奇数
     * @param value
     * @return
     */
    public function odd( value:uint ) : Boolean
    {
        return (1 & value) == 1;
    }
}