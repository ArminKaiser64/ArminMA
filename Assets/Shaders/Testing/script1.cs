using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class script1 : MonoBehaviour
{
    private MeshRenderer cubeRenderer;
    public int zahl;
    void Start()
    {
        cubeRenderer = gameObject.GetComponent<MeshRenderer>();
    }


    void Update()
    {
        cubeRenderer.material.SetFloat("_Displacement", zahl);
    }
}
