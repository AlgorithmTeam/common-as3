package common.mathematics
{
    /**
     * 检测整数是否为偶数
     * @param value
     * @return
     */
    public function even( value:uint ) : Boolean
    {
        return (1 & value) == 0;
    }
}