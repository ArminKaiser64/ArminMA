using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Script2 : MonoBehaviour
{
    private MeshRenderer cubeRenderer;
    public int zahl;
    void Start()
    {
        cubeRenderer = gameObject.GetComponent<MeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        cubeRenderer.material.SetFloat("_Displacement", zahl);

    }
}
